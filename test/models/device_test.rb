require "test_helper"

class DeviceTest < ActiveSupport::TestCase
  test "requires a platform and token" do
    device = users(:lena).devices.new
    assert_not device.valid?
    assert_includes device.errors[:platform], "can't be blank"
    assert_includes device.errors[:token], "can't be blank"
  end

  test "token is unique" do
    device = users(:lena).devices.new(platform: :ios, token: devices(:dana_iphone).token)
    assert_not device.valid?
    assert_includes device.errors[:token], "has already been taken"
  end

  test "a user can have several devices" do
    assert_equal 2, users(:dana).devices.count
    assert_equal %w[ android ios ], users(:dana).devices.map(&:platform).sort
  end

  test "platform name" do
    assert_equal "iOS", devices(:dana_iphone).platform_name
    assert_equal "Android", devices(:dana_tablet).platform_name
  end
end
