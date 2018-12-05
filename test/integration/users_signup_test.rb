require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    # /signupにアクセスする
    # 実際のユーザー操作を模倣している。省略しても一応動く
    get signup_path
    # <form ... action="/signup" ...> というHTMLが存在するか
    assert_select 'form[action="/signup"]'
    
    # ブロック内を実行する前後でUser.countが同値であるかをチェックする
    # （投稿するデータが不正であるため、ユーザー数が増えない）
    assert_no_difference 'User.count' do
      # /usersにpostで不正なデータを送信する 
      post signup_path, params: { user: { name:  "",
                                   email: "user@invalid",
                                   password: "foo",
                                   password_confirmation: "bar" } }
    end
    # users/newに対応するテンプレートが表示されているか
    assert_template 'users/new'
    # <div id="error_explanation">…</div>のようなHTMLが存在するか
    assert_select 'div#error_explanation'
    # <li>{エラーメッセージ}</li>のようなHTMLが存在するか
    assert_select 'li', "Name can't be blank"
    assert_select 'li', 'Email is invalid'
    assert_select 'li', "Password confirmation doesn't match Password"
    assert_select 'li', 'Password is too short (minimum is 6 characters)'
  end
  
  test "valid signup information" do
    # /signupにアクセスする
    get signup_path
    # ブロック内を実行する前後でUser.countが+1違うかをチェックする
    # （投稿するデータが正常であるため、ユーザー数が1増える）
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    # リダイレクトは明示しないといけないらしい
    follow_redirect!
    # users/show.html.erbのテンプレートが表示されているか
    assert_template 'users/show'
    # flashにメッセージが設定されているか
    assert_not flash.empty?
  end
end
