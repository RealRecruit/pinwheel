class CommentMailer < ApplicationMailer
  def created
    @comment = params[:comment]
    @recipient = params[:recipient]
    @project = @comment.project

    mail to: @recipient.email_address, subject: "#{@comment.creator.name} commented on #{@project.name}"
  end
end
