require "test_helper"

class CommentMailerTest < ActionMailer::TestCase
  test "created" do
    comment = comments(:launch_copy)
    mail = CommentMailer.with(comment: comment, recipient: users(:dana)).created

    assert_equal "Lena Ortiz commented on Q4 launch", mail.subject
    assert_equal [ "dana@example.com" ], mail.to
    assert_match "Release notes draft is ready for review.", mail.text_part.body.to_s
    assert_match "http://example.com/accounts/#{accounts(:globex).id}/projects/#{projects(:launch).id}#comment_#{comment.id}", mail.html_part.body.to_s
  end
end
