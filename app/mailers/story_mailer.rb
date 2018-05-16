class StoryMailer < ApplicationMailer
  default from: "Arel from Arelplane <hello@arelplane.com>"

  def new_story(story, follower)
    @story = story
    @story_owner = story.user
    @follower = follower
    mail(
      to: @follower.email,
      reply_to: "no-reply@arelplane.com",
      subject: "A pilot you follow just added a new post!"
    )
  end

  def new_comment(comment)
    @comment = comment
    @commenter = comment.user
    @story = comment.commentable
    @story_owner = @story.user
    mail(
      to: @story_owner.email,
      reply_to: "no-reply@arelplane.com",
      subject: "#{@commenter.username} commented on your post!"
    )
  end

  def new_like(liker, story)
    @liker = liker
    @story = story
    @story_owner = story.user
    mail(
      to: @story_owner.email,
      reply_to: "no-reply@arelplane.com",
      subject: "#{@liker.username} liked your post!"
    )
  end

  def following_story_comment(comment, subscriber)
    @comment = comment
    @commenter = comment.user
    @subscriber = subscriber
    @story = comment.commentable
    @story_owner = @story.user
    mail(
      to: @subscriber.email,
      reply_to: "no-reply@arelplane.com",
      subject: "#{@commenter.username} also commented on #{@story_owner.username}'s post!"
    )
  end
end
