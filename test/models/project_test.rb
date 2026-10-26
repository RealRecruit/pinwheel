require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "requires a name" do
    project = accounts(:globex).projects.new(creator: users(:tom))
    assert_not project.valid?
    assert_includes project.errors[:name], "can't be blank"
  end

  test "defaults creator to the current user" do
    Current.session = users(:lena).sessions.create!
    project = accounts(:globex).projects.create!(name: "Onboarding")
    assert_equal users(:lena), project.creator
  end

  test "active and archived scopes" do
    assert_includes Project.active, projects(:launch)
    assert_not_includes Project.active, projects(:intranet)
    assert_includes Project.archived, projects(:intranet)
  end

  test "archive" do
    project = projects(:launch)
    assert_not project.archived?

    project.archive
    assert project.reload.archived?
  end

  test "assigned users" do
    assert_equal %w[ Dana Lena Tom ], projects(:launch).assigned_users.map(&:first_name).sort
  end

  test "assignable users excludes people already on the project" do
    assert_equal [ users(:tom) ], projects(:billing).assignable_users.to_a
  end
end
