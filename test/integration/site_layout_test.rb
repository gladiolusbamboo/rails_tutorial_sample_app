require 'test_helper'

# 統合テストを行う
class SiteLayoutTest < ActionDispatch::IntegrationTest
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
  end
end
