require "test_helper"

class AssignmentMailerTest < ActionMailer::TestCase
  test "assigned" do
    mail = AssignmentMailer.assigned(assignments(:dana_launch))

    assert_equal "You've been added to Q4 launch", mail.subject
    assert_equal [ "dana@example.com" ], mail.to
    assert_match "You've been added to Q4 launch in Globex.", mail.text_part.body.to_s
    assert_match "http://example.com/accounts/#{accounts(:globex).id}/projects/#{projects(:launch).id}", mail.html_part.body.to_s
  end
end
