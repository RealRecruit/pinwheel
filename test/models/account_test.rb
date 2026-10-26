require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "requires a name" do
    assert_not Account.new.valid?
  end

  test "users through memberships" do
    assert_equal %w[ dana@example.com lena@example.com tom@example.com ], accounts(:globex).users.pluck(:email_address).sort
  end
end
