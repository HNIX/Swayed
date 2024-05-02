require "test_helper"

class Jumpstart::StaticTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end 
  
  test "homepage" do
    get root_path
    assert_response :success
  end

  test "dashboard" do
    sign_in users(:one)
    get root_path
    assert_select "h1", I18n.t("dashboard.show.title")
  end
end
