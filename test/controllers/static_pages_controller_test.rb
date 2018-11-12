require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  # 各テストの前に実行されるメソッド
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end
  
  # ルートURLにアクセスしたときにレスポンスが返ってくるか
  test "should get root" do
    get root_url
    assert_response :success
  end
  
  # static_pagesコントローラーのhomeアクションに対応するURLにアクセスしたときに
  # レスポンスが返ってくるか
  # <title>タグの内容は"Home | Ruby on Rails Tutorial Sample App"であるか
  test "should get home" do
    get static_pages_home_url
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

  # static_pagesコントローラーのhelpアクションに対応するURLにアクセスしたときに
  # レスポンスが返ってくるか
  # <title>タグの内容は"Help | Ruby on Rails Tutorial Sample App"であるか
  test "should get help" do
    get static_pages_help_url
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end
  
  # static_pagesコントローラーのaboutアクションに対応するURLにアクセスしたときに
  # レスポンスが返ってくるか
  # <title>タグの内容は"About | Ruby on Rails Tutorial Sample App"であるか
  test "should get about" do
    get static_pages_about_url
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end
end
