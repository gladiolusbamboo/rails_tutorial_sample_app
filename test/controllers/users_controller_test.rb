require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # @userにfixturesで定義したテスト用データを設定する
  def setup
    @user = users(:michael)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  # ログインせずにユーザーデータを編集しようとしたときに
  # ログイン用URLへリダイレクトされるか
  test "should redirect edit when not logged in" do
    # ログインしていない状態で
    # GETで/users/1/editにアクセスする
    get edit_user_path(@user)
    # flashにメッセージが入っているか
    assert_not flash.empty?
    # ログイン用URLへリダイレクトされるか
    assert_redirected_to login_url
  end

  # ログインせずにユーザーデータを更新しようとしたときに
  # ログイン用URLへリダイレクトされるか
  test "should redirect update when not logged in" do
    # ログインしていない状態で
    # PATCHTで/users/1にデータを送信する
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    # flashにメッセージが入っているか
    assert_not flash.empty?
    # ログイン用URLへリダイレクトされるか
    assert_redirected_to login_url
  end
end
