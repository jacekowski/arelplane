class LocationMailer < ApplicationMailer
  default from: "Arel from Arelplane <hello@arelplane.com>"

  def update_submitted(location)
    @location = location
    mail(
     to: 'arel@arelplane.com',
     reply_to: "arel@arelplane.com",
     subject: "#{@location.identifier} was updated"
   )
  end
end
