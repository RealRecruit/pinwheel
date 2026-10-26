require "test_helper"

class Projects::ArchivalsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as users(:tom) }

  test "create" do
    post account_project_archival_path(accounts(:globex), projects(:launch))

    assert_redirected_to account_projects_path(accounts(:globex))
    assert projects(:launch).reload.archived?
  end

  test "create emails everyone assigned to the project" do
    project = projects(:launch)

    assert_enqueued_emails 3 do
      post account_project_archival_path(accounts(:globex), project)
    end

    project.assigned_users.each do |user|
      assert_enqueued_email_with ProjectMailer, :archived, params: { project: project, user: user }
    end

    perform_enqueued_jobs
    assert_equal %w[ dana@example.com lena@example.com tom@example.com ], ActionMailer::Base.deliveries.flat_map(&:to).sort
  end

  test "non-members can't archive" do
    sign_in_as users(:marcus)

    post account_project_archival_path(accounts(:globex), projects(:launch))

    assert_response :not_found
    assert_not projects(:launch).reload.archived?
    assert_no_enqueued_emails
  end
end
