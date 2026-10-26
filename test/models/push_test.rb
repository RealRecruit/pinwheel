require "test_helper"

class PushTest < ActiveSupport::TestCase
  test "deliver creates a delivery for each of the user's devices" do
    assert_difference -> { users(:dana).push_deliveries.count }, 2 do
      Push.deliver(user: users(:dana), title: "Hello", body: "Testing")
    end

    deliveries = users(:dana).push_deliveries.order(:id).last(2)
    assert_equal [ devices(:dana_iphone), devices(:dana_tablet) ].sort_by(&:id), deliveries.map(&:device).sort_by(&:id)
    assert deliveries.all? { |delivery| delivery.title == "Hello" && delivery.delivered_at.present? }
  end

  test "deliver to a user without devices" do
    assert_no_difference -> { PushDelivery.count } do
      assert_empty Push.deliver(user: users(:lena), title: "Hello", body: "Testing")
    end
  end
end
