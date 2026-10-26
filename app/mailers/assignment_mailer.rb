class AssignmentMailer < ApplicationMailer
  def assigned(assignment)
    @assignment = assignment
    @project = assignment.project
    @user = assignment.user

    mail to: @user.email_address, subject: "You've been added to #{@project.name}"
  end
end
