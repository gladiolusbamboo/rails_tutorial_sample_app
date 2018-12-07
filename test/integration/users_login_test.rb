require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # ログインで誤った情報を与えた場合の挙動は正しいか
  test "login with invalid information" do
    # /loginにGETでアクセスする
    get login_path
    # sessionsコントローラーのnewレイアウトが適用されているか
    assert_template 'sessions/new'
    # /loginにPOSTで誤ったログイン情報を送信する
    post login_path, params: { session: { email: "", password: "" } }
    # sessionsコントローラーのnewレイアウトが適用されているか
    assert_template 'sessions/new'
    # flashにエラーメッセージが入っているか
    assert_not flash.empty?
    # /にGETでアクセスする
    get root_path
    # flashは空になっているか
    assert flash.empty?
  end
end
