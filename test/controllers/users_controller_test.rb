require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # @userにfixturesで定義したテスト用データを設定する
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
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
  
  # 間違ったユーザーがユーザーデータ編集画面へアクセスした場合
  # flashを出さずにルートへリダイレクトする
  test "should redirect edit when logged in as wrong user" do
    # 間違ったユーザーでログインする
    log_in_as(@other_user)
    # GETで/users/1/editにアクセスする
    get edit_user_path(@user)
    # flashは空か？
    assert flash.empty?
    # ルートにリダイレクトされるか
    assert_redirected_to root_url
  end

  # 間違ったユーザーがユーザーデータを編集しようとした場合
  # flashを出さずにルートへリダイレクトする
  test "should redirect update when logged in as wrong user" do
    # 間違ったユーザーでログインする
    log_in_as(@other_user)
    # PATCHTで/users/1にデータを送信する
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    # flashは空か？
    assert flash.empty?
    # ルートにリダイレクトされるか
    assert_redirected_to root_url
  end
  
  # ログインしていない時、
  # GETで/usersにアクセスしたときに
  # ログインページへリダイレクトされるか
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  # admin属性は変更できないことを確認する
  test "should not allow the admin attribute to be edited via the web" do
    # 管理者でないユーザーでログインする
    log_in_as(@other_user)
    # 管理者権限はないか
    assert_not @other_user.admin?
    # PATCHで管理者権限を与えようとする
    patch user_path(@other_user), params: {
                                  user: { password:              "password",
                                          password_confirmation: "password",
                                          admin: true } }
    # 管理者権限がちゃんと制限されているか
    assert_not @other_user.reload.admin?
  end
  
  # ログインしていないときに
  # ユーザーを削除しようとした場合、
  # ログインページへリダイレクトするか
  test "should redirect destroy when not logged in" do
    # ブロックを実行する前後でUser.countが同値か
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  # 管理権限のないユーザーで
  # 別のユーザーを削除しようとした場合、
  # ログインページへリダイレクトするか
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  
  # ログインしていない状態でフォロー相手を見ようとした場合、
  # ログインページにリダイレクトされるか
  test "should redirect following when not logged in" do
    # /users/:id/followingにGETアクセス
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  # ログインしていない状態でフォロワーを見ようとした場合、
  # ログインページにリダイレクトされるか
  test "should redirect followers when not logged in" do
    # /users/:id/followersにGETアクセス
    get followers_user_path(@user)
    assert_redirected_to login_url
  end
end
