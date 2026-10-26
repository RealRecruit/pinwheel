class AssignmentNotificationJob < ApplicationJob
  queue_as :default

  def perform(assignment)
    AssignmentMailer.assigned(assignment).deliver_now

    Push.deliver \
      user: assignment.user,
      title: "Added to #{assignment.project.name}",
      body: "You're now on #{assignment.project.name} in #{assignment.project.account.name}."
  end
end
