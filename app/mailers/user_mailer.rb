class UserMailer < ApplicationMailer
  default from: "Arel from Arelplane <hello@arelplane.com>"

  def welcome_email(user)
    @user = user
    mail(
     to: @user.email,
     reply_to: "arel@arelplane.com",
     subject: "How can I make Arelplane more helpful for you?"
   )
  end

  def new_follower(follower, following)
    @follower = follower
    @following = following
    mail(
      to: @following.email,
      reply_to: "no-reply@arelplane.com",
      subject: "#{@follower.name liked your map!}"
    )
  end
end
