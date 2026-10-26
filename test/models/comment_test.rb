require "test_helper"

class CommentTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  test "requires a body" do
    comment = projects(:launch).comments.new(creator: users(:tom), body: " ")
    assert_not comment.valid?
    assert_includes comment.errors[:body], "can't be blank"
  end

  test "chronologically" do
    assert_equal [ comments(:launch_checklist), comments(:launch_copy) ], projects(:launch).comments.chronologically.to_a
  end

  test "defaults creator to the current user" do
    Current.session = users(:lena).sessions.create!
    comment = projects(:launch).comments.create!(body: "Looks good")
    assert_equal users(:lena), comment.creator
  end

  test "emails everyone assigned to the project except the author" do
    assert_enqueued_emails 2 do
      @comment = projects(:launch).comments.create!(creator: users(:lena), body: "Copy is final.")
    end

    assert_enqueued_email_with CommentMailer, :created, params: { comment: @comment, recipient: users(:dana) }
    assert_enqueued_email_with CommentMailer, :created, params: { comment: @comment, recipient: users(:tom) }
  end

  test "no email when the author is the only one assigned" do
    project = accounts(:globex).projects.create!(name: "Solo", creator: users(:tom))
    project.assignments.create!(user: users(:tom))

    assert_no_enqueued_emails do
      project.comments.create!(creator: users(:tom), body: "Notes to self")
    end
  end

  test "no email for people who aren't assigned" do
    assert_enqueued_emails 1 do
      projects(:billing).comments.create!(creator: users(:lena), body: "Tom, can you take a look?")
    end
  end
end
