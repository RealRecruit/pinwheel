require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "index lists the user's accounts" do
    sign_in_as users(:dana)
    get root_path

    assert_response :success
    assert_select "main a", text: "Northwind"
    assert_select "main a", text: "Globex"
  end

  test "index only shows accounts the user belongs to" do
    sign_in_as users(:marcus)
    get root_path

    assert_select "main a", text: "Northwind"
    assert_select "main a", text: "Globex", count: 0
  end
end
