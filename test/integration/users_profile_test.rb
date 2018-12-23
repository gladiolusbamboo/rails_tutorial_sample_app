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
  
  # フォロー・フォロワー数がちゃんと表示されているか
  test "follower statics display" do
    get root_path
    assert_select 'section.stats', count: 0
    assert_select 'div.stats', count: 0
    log_in_as @user
    get root_path
    assert_select 'section.stats'
    assert_select 'div.stats'
  end

  # フォロー・アンフォローボタンが正常に表示されているか
  test "follow button display" do
    log_in_as @user
    archer = users(:archer)
    get user_path archer
    # <input value="Follow">...</input>
    # みたいなHTMLが含まれているか
    assert_select 'input[value=Follow]'
    @user.follow(archer)
    get user_path archer
    assert_select 'section.stats'
    assert_select 'div.stats'
    assert_select 'input[value=Follow]', count: 0
    assert_select 'input[value=Unfollow]'
  end
end
