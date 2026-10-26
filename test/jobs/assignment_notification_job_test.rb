require "test_helper"

class AssignmentNotificationJobTest < ActiveJob::TestCase
  include ActionMailer::TestHelper

  test "emails the assignee and pushes to each of their devices" do
    project = accounts(:globex).projects.create!(name: "Trade show", creator: users(:tom))
    assignment = project.assignments.create!(user: users(:dana))

    assert_emails 1 do
      assert_difference -> { users(:dana).push_deliveries.count }, 2 do
        AssignmentNotificationJob.perform_now(assignment)
      end
    end

    assert_equal [ "dana@example.com" ], ActionMailer::Base.deliveries.last.to
    assert_equal [ devices(:dana_iphone), devices(:dana_tablet) ].map(&:id).sort, users(:dana).push_deliveries.pluck(:device_id).sort
    assert_equal "Added to Trade show", users(:dana).push_deliveries.last.title
  end

  test "assignee without devices still gets the email" do
    assignment = projects(:website).assignments.find_by!(user: users(:marcus))

    assert_emails 1 do
      assert_no_difference -> { PushDelivery.count } do
        AssignmentNotificationJob.perform_now(assignment)
      end
    end
  end
end
