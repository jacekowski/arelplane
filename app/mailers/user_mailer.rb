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
      subject: "#{@follower.name} followed you!"
    )
  end

  def new_comment(commenter, story)
    @commenter = commenter
    @story = story
    @story_owner = story.user
    mail(
      to: @story_owner.email,
      reply_to: "no-reply@arelplane.com",
      subject: "#{@commenter.name} commented on your post!"
    )
  end

  def new_like(liker, story)
    @liker = liker
    @story = story
    @story_owner = story.user
    mail(
      to: @story_owner.email,
      reply_to: "no-reply@arelplane.com",
      subject: "#{@liker.name} liked your post!"
    )
  end

  def following_story_comment(new_commenter, previous_commenter, story)
    @new_commenter = new_commenter
    @previous_commenter = previous_commenter
    @story = story
    mail(
      to: @new_commenter.email,
      reply_to: "no-reply@arelplane.com",
      subject: "#{@new_commenter.name} also commented on #{@story.user.name}'s post!"
    )
  end
end
