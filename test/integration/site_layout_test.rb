require 'test_helper'

# 統合テストを行う
class SiteLayoutTest < ActionDispatch::IntegrationTest
  # テストの前に実行する
  # @userにfixturesで生成したユーザーデータを設定する
  def setup
    @user = users(:michael)
  end

  test "layout links" do
    # ルートURLにGETでアクセスしたとき
    get root_path
    # static_pages/homeに対応するテンプレートが表示されているか
    assert_template 'static_pages/home'
    # <a href=(root_path)>...</a>のようなHTMLが２個存在するか
    assert_select "a[href=?]", root_path, count: 2
    # <a href=(help_path)>...</a>のようなHTMLが存在するか
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path

    # contact_pathに対応するURLにGETでアクセスしたときに
    get contact_path
    # <title>タグの中身はfull_title("Contact")と同値か
    # full_titleはapplication_helper.rbで定義している
    assert_select "title", full_title("Contact")
    
    # signup_pathに対応するURLにGETでアクセスしたときに
    get signup_path
    assert_response :success
    # <title>タグの中身はfull_title("Sign up")と同値か
    assert_select "title", full_title("Sign up")
    
    # help_path
    get help_path
    assert_response :success
    assert_select "title", full_title("Help")

    # login_path
    get login_path
    assert_response :success
    assert_select "title", full_title("Log in")
    
    # /usersアクセステスト
    # ログインしていない状態で/usersにアクセスしたときに
    get users_path
    # ログインページにリダイレクトされるか
    assert_redirected_to login_path
    # ログインして
    log_in_as(@user)
    # /usersにGETでアクセスする
    get users_path
    # usersコントローラーのindexレイアウトが適用されるか
    assert_template 'users/index'
    # ログアウトする
    log_out
    
    # /users/1アクセステスト
    # ログインしていない状態で/usersにアクセスしたときに
    # 正しいレイアウトが適用されているか
    get user_path @user
    assert_response :success
    assert_template 'users/show'
    # ログインしても同じか
    log_in_as(@user)
    get user_path @user
    assert_response :success
    assert_template 'users/show'
    log_out

    # /users/1/editアクセステスト
    # ログインしていない状態で/usersにアクセスしたときに
    # 正しいレイアウトが適用されているか
    get edit_user_path @user
    assert_redirected_to login_path
    log_in_as @user
    get edit_user_path @user
    assert_response :success
    assert_template 'users/edit'
    
  end
end
