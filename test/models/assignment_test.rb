require "test_helper"

class AssignmentTest < ActiveSupport::TestCase
  test "a user can only be assigned once" do
    assignment = projects(:launch).assignments.new(user: users(:dana))
    assert_not assignment.valid?
    assert_includes assignment.errors[:user_id], "has already been taken"
  end

  test "user must belong to the project's account" do
    assignment = projects(:launch).assignments.new(user: users(:marcus))
    assert_not assignment.valid?
    assert_includes assignment.errors[:user], "isn't a member of this account"
  end

  test "valid for an account member" do
    assert projects(:billing).assignments.new(user: users(:tom)).valid?
  end
end
