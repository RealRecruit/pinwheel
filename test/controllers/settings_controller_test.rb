require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as users(:dana) }

  test "show" do
    get settings_path
    assert_response :success
    assert_select "input[name='user[name]'][value='Dana Whitfield']"
    assert_select "td", text: "Dana's iPhone"
    assert_select "td", text: "Dana's Galaxy Tab"
  end

  test "update" do
    patch settings_path, params: { user: { name: "Dana W.", email_address: "dana.w@example.com" } }

    assert_redirected_to settings_path
    assert_equal "Dana W.", users(:dana).reload.name
    assert_equal "dana.w@example.com", users(:dana).email_address
  end

  test "update with invalid params" do
    patch settings_path, params: { user: { name: "", email_address: "dana@example.com" } }

    assert_response :unprocessable_entity
    assert_equal "Dana Whitfield", users(:dana).reload.name
  end

  test "requires authentication" do
    sign_out
    get settings_path
    assert_redirected_to new_session_path
  end
end
