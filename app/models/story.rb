class Story < ApplicationRecord
  default_scope { order(created_at: :desc) }

  belongs_to :user
  has_many :flights, dependent: :nullify
  accepts_nested_attributes_for :flights, reject_if: :reject_flight

  has_many :waypoints, through: :flights
  accepts_nested_attributes_for :waypoints, reject_if: lambda { |a| a[:location_id].blank? }

  has_many :destinations, through: :flights, source: :destination
  has_many :origins, through: :flights, source: :origin
  has_many :user_ratings
  has_many :ratings, through: :user_ratings, dependent: :destroy

  has_many :comments, as: :commentable
  has_many :likes, as: :likeable, dependent: :destroy

  validate :presence_of_description_if_no_attachments

  after_create :fetch_image

  def presence_of_description_if_no_attachments
    if flights.blank? && ratings.blank? && description.blank?
      errors.add(:description, 'required if no new flights or ratings are added')
    end
  end

  def reject_flight(attributes)
    attributes['origin_id'].blank? &&
    attributes['destination_id'].blank?
  end

  def fetch_image
    if self.flights.any?
      CreateStoryImageJob.perform_now(self)
    end
  end

  def locations
    waypoint_locations = waypoints.map {|w| w.location }
    origins + waypoint_locations + destinations
  end

  def airports
    flights.pluck(:origin_id, :destination_id).flatten
  end

  def num_airports
    waypoints.each do |wp|
      if wp.location.location_type.try(:include?, "airport")
        airports << wp.location.id
      end
    end
    airports.flatten.uniq.count
  end

  def total_flight_hours
    flights.pluck(:total_time).compact.sum.round(1)
  end

  def num_regions
    locations = (waypoints.pluck(:location_id) + airports).flatten
    Location.find(locations.uniq).pluck(:iso_region).uniq.count
  end

  def self.smart_feed
    feed = []
    self.find_each(batch_size: 10).group_by do |story|
      [story.user_id, story.created_at.beginning_of_hour]
    end.map do |match|
      stories = match.second
      user_id = match.first.first
      if stories.count > 1
        temp_story = self.new(user_id: user_id)
        stories.map do |story|
          if story.ratings.any?
            temp_story.ratings.append(story.ratings)
          elsif story.flights.any?
            temp_story.flights.append(story.flights)
          end
        end
        if temp_story.ratings.any? && temp_story.flights.any?
          temp_story.description = "Added #{ActionController::Base.helpers.pluralize(temp_story.ratings.size, 'new rating')} and #{ActionController::Base.helpers.pluralize(temp_story.flights.size, 'new flight')}."
        elsif temp_story.ratings.any?
          temp_story.description = "Added #{ActionController::Base.helpers.pluralize(temp_story.ratings.size, 'new rating')}."
        elsif temp_story.flights.any?
          temp_story.description = "Added #{ActionController::Base.helpers.pluralize(temp_story.flights.size, 'new flight')}."
        end
        feed.append(temp_story)
      else
        feed.append(stories.first)
      end
    end
    return feed.reverse
  end

  def persist_if_flights
    if self.flights.any?
      self.save
    end
  end

end
