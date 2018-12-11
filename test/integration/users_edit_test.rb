require 'test_helper'

# ユーザーデータ編集のテスト
class UsersEditTest < ActionDispatch::IntegrationTest
  # fixturesで設定したデータを取得
  def setup
    @user = users(:michael)
  end

  # 失敗例
  test "unsuccessful edit" do
    # ログインする
    log_in_as(@user)
    # GETで/users/:id/editにアクセスする
    get edit_user_path(@user)
    # /sample_app/app/views/users/edit.html.erb
    # のテンプレートが適用されているか
    assert_template 'users/edit'
    # PATCHで/users/:idにデータを送信する
    patch user_path(@user), params: { user: { name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    # /sample_app/app/views/users/edit.html.erb
    # のテンプレートが適用されているか
    assert_template 'users/edit'
    # <div class="alert-danger">The form contains 4 errors.</div>
    # みたいなHTMLがあるか
    assert_select "div.alert-danger", "The form contains 4 errors." 
  end
  
  # ユーザーデータ編集成功
  test "successful edit with friendly forwarding" do
    # ログインしていない状態で
    # GETで/users/:id/editにアクセスする
    get edit_user_path(@user)
    # その後ログインする
    log_in_as(@user)
    # リダイレクト先がユーザーデータの編集ページか
    assert_redirected_to edit_user_url(@user)
    # 実際にリダイレクトする
    follow_redirect!
    # /sample_app/app/views/users/edit.html.erb
    # のテンプレートが適用されているか
    assert_template 'users/edit'
    # ユーザーデータを編集する
    name  = "Foo Bar"
    email = "foo@bar.com"
    # PATCHで/users/:idにデータを送信する
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    # flashにメッセージ（編集成功）がセットされるか                                              
    assert_not flash.empty?
    # ユーザーデータへリダイレクトされるか
    assert_redirected_to @user
    # @userに代入されているユーザーデータを更新する
    @user.reload
    # ちゃんと変更されているか
    assert_equal name,  @user.name
    assert_equal email, @user.email
    
    # 再びログインする
    log_in_as(@user)
    # 転送先URLが初期化されているか
    assert_equal session[:forwarding_url], nil

    
  end
end