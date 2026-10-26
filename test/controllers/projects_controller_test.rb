require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as users(:dana) }

  test "index lists active projects" do
    get account_projects_path(accounts(:globex))

    assert_response :success
    assert_select "li", text: /Q4 launch/
    assert_select "li", text: /Old intranet/, count: 0
  end

  test "index with archived filter" do
    get account_projects_path(accounts(:globex), archived: true)

    assert_response :success
    assert_select "li", text: /Old intranet/
    assert_select "li", text: /Q4 launch/, count: 0
  end

  test "show" do
    get account_project_path(accounts(:globex), projects(:launch))

    assert_response :success
    assert_select "h1", "Q4 launch"
    assert_select "#comments li", 2
  end

  test "create" do
    assert_difference -> { accounts(:northwind).projects.count } do
      post account_projects_path(accounts(:northwind)), params: { project: { name: "Spring catalog", description: "Photos and copy" } }
    end

    project = Project.last
    assert_redirected_to account_project_path(accounts(:northwind), project)
    assert_equal users(:dana), project.creator
  end

  test "create with invalid params" do
    assert_no_difference -> { Project.count } do
      post account_projects_path(accounts(:northwind)), params: { project: { name: "" } }
    end

    assert_response :unprocessable_entity
  end

  test "non-members can't see another account's projects" do
    sign_in_as users(:marcus)

    get account_projects_path(accounts(:globex))
    assert_response :not_found

    get account_project_path(accounts(:globex), projects(:launch))
    assert_response :not_found
  end

  test "projects are looked up within the account in the url" do
    get account_project_path(accounts(:northwind), projects(:launch))
    assert_response :not_found
  end
end
