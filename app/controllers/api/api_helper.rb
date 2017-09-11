module Api::ApiHelper
  def self.included(other)
    other.skip_before_action :verify_authenticity_token
    other.before_action :skip_trackable
    other.respond_to :json
  end

  # We skip tracking logins on API requests because the user authenticates with every request
  def skip_trackable
    request.env['devise.skip_trackable'] = true
  end

end
