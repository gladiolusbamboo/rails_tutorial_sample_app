require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    # /loginにGETでアクセスする
    get login_path
    assert_response :success
  end

end
