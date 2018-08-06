class UserMailer < ApplicationMailer
  default from: "Arel from Arelplane <hello@arelplane.com>"

  def welcome_email(user)
    @user = user
    mail(
     to: @user.email,
     reply_to: "arel@arelplane.com",
     subject: "Welcome to Arelplane!"
   )
  end

  def new_follower(follower, following)
    @follower = follower
    @following = following
    mail(
      to: @following.email,
      reply_to: "no-reply@arelplane.com",
      subject: "#{@follower.username} followed you!"
    )
  end
end
