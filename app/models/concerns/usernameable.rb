module Usernameable
  extend ActiveSupport::Concern

  def create_username(name)
    clean_name = name.downcase.gsub(/[^0-9A-Za-z]/, "")
    unless clean_name[0] == "@" || clean_name.blank?
      clean_name.prepend("@")
    end
  end
end
