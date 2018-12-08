require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # テストの前に実行する
  # @userにfixturesで生成したユーザーデータを設定する
  def setup
    @user = users(:michael)
  end

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
  
  # 正しい情報でログインしてログアウトまでできるかのテスト
  test "login with valid information followed by logout" do
    # /loginにGETでアクセスする
    get login_path
    # /loginにPOSTで正しいログイン情報を送信する
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    # リダイレクト先が@userであるか
    assert_redirected_to @user
    # 実際にリダイレクトする
    follow_redirect!
    # usersコントローラーのshowレイアウトが適用されているか
    assert_template 'users/show'
    # ログインへのリンクがなくなっているか
    assert_select "a[href=?]", login_path, count: 0
    # ログアウトのリンクがあるか
    assert_select "a[href=?]", logout_path
    # ユーザー情報(@user)へのリンクがあるか
    assert_select "a[href=?]", user_path(@user)
    # /loginにDELETEでアクセスする（内部的にはPOSTらしい）
    delete logout_path
    # ログアウトされたか
    assert_not is_logged_in?
    # ログアウト後のリダイレクト先はroot_urlか(root_pathでもおｋ？)
    assert_redirected_to root_url
    # リダイレクト処理
    follow_redirect!
    # ログインリンクがあるか
    assert_select "a[href=?]", login_path
    # ログアウトリンクがなくなったか
    assert_select "a[href=?]", logout_path,      count: 0
    # ユーザー情報へのリンクがなくなったか
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
