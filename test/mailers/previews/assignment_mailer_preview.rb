class AssignmentMailerPreview < ActionMailer::Preview
  def assigned
    AssignmentMailer.assigned(Assignment.last)
  end
end
