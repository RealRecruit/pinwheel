require "test_helper"

class PushDeliveryTest < ActiveSupport::TestCase
  test "requires a title" do
    delivery = PushDelivery.new(user: users(:tom), device: devices(:tom_pixel))
    assert_not delivery.valid?
    assert_includes delivery.errors[:title], "can't be blank"
  end

  test "belongs to a user and a device" do
    delivery = push_deliveries(:tom_welcome)
    assert_equal users(:tom), delivery.user
    assert_equal devices(:tom_pixel), delivery.device
  end
end
