require "test_helper"

class AssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as users(:tom) }

  test "create" do
    assert_difference -> { projects(:billing).assignments.count } do
      post account_project_assignments_path(accounts(:globex), projects(:billing)), params: { assignment: { user_id: users(:tom).id } }
    end

    assert_redirected_to account_project_path(accounts(:globex), projects(:billing))
    assert_includes projects(:billing).assigned_users, users(:tom)
  end

  test "create notifies the assignee" do
    assert_enqueued_with job: AssignmentNotificationJob do
      post account_project_assignments_path(accounts(:globex), projects(:billing)), params: { assignment: { user_id: users(:tom).id } }
    end

    assert_difference -> { users(:tom).push_deliveries.count } do
      perform_enqueued_jobs
    end

    assert_equal [ "tom@example.com" ], ActionMailer::Base.deliveries.last.to
  end

  test "create for someone outside the account" do
    assert_no_difference -> { Assignment.count } do
      post account_project_assignments_path(accounts(:globex), projects(:billing)), params: { assignment: { user_id: users(:marcus).id } }
    end

    assert_redirected_to account_project_path(accounts(:globex), projects(:billing))
    assert_equal "User isn't a member of this account", flash[:alert]
    assert_no_enqueued_jobs only: AssignmentNotificationJob
  end

  test "non-members can't assign people" do
    sign_in_as users(:marcus)

    assert_no_difference -> { Assignment.count } do
      post account_project_assignments_path(accounts(:globex), projects(:billing)), params: { assignment: { user_id: users(:marcus).id } }
    end

    assert_response :not_found
  end
end
