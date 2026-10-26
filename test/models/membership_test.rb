require "test_helper"

class MembershipTest < ActiveSupport::TestCase
  test "defaults to member" do
    assert Membership.new.member?
  end

  test "a user can only join an account once" do
    membership = Membership.new(account: accounts(:globex), user: users(:dana))
    assert_not membership.valid?
    assert_includes membership.errors[:user_id], "has already been taken"
  end

  test "a user can belong to several accounts with different roles" do
    dana = users(:dana)

    assert_equal [ accounts(:globex), accounts(:northwind) ].sort_by(&:name), dana.accounts.order(:name).to_a
    assert dana.admin_of?(accounts(:northwind))
    assert_not dana.admin_of?(accounts(:globex))
  end
end
