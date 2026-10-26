require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as users(:lena) }

  test "create" do
    assert_difference -> { projects(:launch).comments.count } do
      post account_project_comments_path(accounts(:globex), projects(:launch)), params: { comment: { body: "Screenshots are uploaded." } }
    end

    comment = Comment.last
    assert_redirected_to account_project_path(accounts(:globex), projects(:launch), anchor: "comment_#{comment.id}")
    assert_equal users(:lena), comment.creator
  end

  test "create emails the other people on the project" do
    assert_enqueued_emails 2 do
      post account_project_comments_path(accounts(:globex), projects(:launch)), params: { comment: { body: "Screenshots are uploaded." } }
    end

    perform_enqueued_jobs

    assert_equal %w[ dana@example.com tom@example.com ], ActionMailer::Base.deliveries.flat_map(&:to).sort
  end

  test "create with a blank body" do
    assert_no_difference -> { Comment.count } do
      post account_project_comments_path(accounts(:globex), projects(:launch)), params: { comment: { body: "" } }
    end

    assert_response :unprocessable_entity
  end

  test "non-members can't comment" do
    sign_in_as users(:marcus)

    assert_no_difference -> { Comment.count } do
      post account_project_comments_path(accounts(:globex), projects(:launch)), params: { comment: { body: "Hello?" } }
    end

    assert_response :not_found
  end
end
