class AssignmentsController < ApplicationController
  include AccountScoped
  include ProjectScoped

  def create
    @assignment = @project.assignments.new(assignment_params)

    if @assignment.save
      AssignmentNotificationJob.perform_later(@assignment)
      redirect_to account_project_path(Current.account, @project), notice: "#{@assignment.user.name} was assigned."
    else
      redirect_to account_project_path(Current.account, @project), alert: @assignment.errors.full_messages.to_sentence
    end
  end

  private
    def assignment_params
      params.expect(assignment: [ :user_id ])
    end
end
