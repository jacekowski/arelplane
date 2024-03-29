module ApplicationHelper
  def title(page_title)
    content_for(:title) { page_title }
  end

  def image(story_image)
    content_for(:image) { story_image }
  end

  def resource_name
   :user
  end

  def resource_class
    User
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
