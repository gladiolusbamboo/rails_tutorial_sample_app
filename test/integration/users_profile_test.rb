require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  # /sample_app/test/helpers/application_helper_test.rb
  # のヘルパーメソッドが使用できる
  include ApplicationHelper
  
  def setup
    @user = users(:michael)
  end
  
  test "profile display" do
    # ユーザープロフィールへGETアクセスする
    get user_path(@user)
    # users/showレイアウトが適用されているか
    assert_template 'users/show'
    # <title>{full_title(@user.name)}</title>
    # みたいなHTMLがあるか
    assert_select 'title', full_title(@user.name)
    # <h1>{@user.name}</h1>
    # みたいなHTMLがあるか
    assert_select 'h1', text: @user.name
    # <h1><img class='gravatar'>...</h1>
    # みたいなHTMLがあるか
    assert_select 'h1>img.gravatar'
    # HTML全体(response.body)に{@user.microposts.count.to_s}
    # が含まれているか
    assert_match @user.microposts.count.to_s, response.body
    # <div class='pagination'>...</div>みたいなHTMLが1箇所だけあるか
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |micropost|
      # HTML全体(response.body)に{micropost.content}
      # が含まれているか
      assert_match micropost.content, response.body
    end
  end
end
