class UserMailer < ApplicationMailer
  default from: "Arel from Arelplane <hello@arelplane.com>"

  def welcome_email(user)
    @user = user
    mail(
     to: @user.email,
     subject: "How can I make Arelplane more helpful for you?"
   )
  end
end
