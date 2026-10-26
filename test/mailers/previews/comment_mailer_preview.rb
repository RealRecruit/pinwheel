class CommentMailerPreview < ActionMailer::Preview
  def created
    comment = Comment.last
    CommentMailer.with(comment: comment, recipient: comment.project.assigned_users.first || comment.creator).created
  end
end
