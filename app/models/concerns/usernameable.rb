module Usernameable
  extend ActiveSupport::Concern

  def create_username(name)
    name.downcase.gsub(/[^0-9A-Za-z]/, "")
  end
end
