require "test_helper"

class ProjectMailerTest < ActionMailer::TestCase
  test "archived" do
    project = projects(:intranet)
    mail = ProjectMailer.with(project: project, user: users(:dana)).archived

    assert_equal "Old intranet was archived", mail.subject
    assert_equal [ "dana@example.com" ], mail.to
    assert_match "Old intranet in Globex was archived on #{project.archived_at.to_date.to_fs(:long)}", mail.text_part.body.to_s
    assert_match "http://example.com/accounts/#{accounts(:globex).id}/projects/#{project.id}", mail.html_part.body.to_s
  end
end
