class SubscriptionsController < ApplicationController
  before_action :set_subscription_preference, only: :show
  before_action :set_user, only: :show

  def show
    case params[:unsubscribe]
    when "everything"
      @subscription_preference.update_attributes(no_emails: true)
      redirect_to unsubscribe_confirmation_path(type: 'all emails')
    when "all_stories"
      @subscription_preference.update_attributes(story_emails: false)
      redirect_to unsubscribe_confirmation_path(type: 'all posts')
    when "new_followers"
      @subscription_preference.update_attributes(new_follower_email: false)
      redirect_to unsubscribe_confirmation_path(type: 'new follower emails')
    when "story"
      if story = Story.find(params[:story_id])
        story.subscriptions.find_by(user: @user).try(:destroy)
      end
      redirect_to unsubscribe_confirmation_path(type: 'this post')
    end
  end

private
  def set_subscription_preference
    @subscription_preference = SubscriptionPreference.find_by(unsubscribe_token: params[:token])
  end

  def set_user
    @user = @subscription_preference.user
  end
end
