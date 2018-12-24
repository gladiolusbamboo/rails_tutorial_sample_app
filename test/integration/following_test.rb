require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  # フォロー先一覧ページのテスト
  test "following page" do
    # /users/:id/followingにGETでアクセスする
    get following_user_path(@user)
    # @userのフォロー先ユーザーがいるか
    assert_not @user.following.empty?
    # @userのフォロー数が表示されているか
    assert_match @user.following.count.to_s, response.body
    # @userのフォロー相手のプロフィールへのリンクが表示されているか
    @user.following.each do |user|
      # <a href="/user/{:id}">...</a>
      # みたいなリンクが表示されているか
      assert_select "a[href=?]", user_path(user)
    end
  end

  # フォロワー一覧ページのテスト
  test "followers page" do
    # /users/:id/followersにGETでアクセスする
    get followers_user_path(@user)
    # @userのフォロワーのユーザーがいるか
    assert_not @user.followers.empty?
    # @userのフォロワー数が表示されているか
    assert_match @user.followers.count.to_s, response.body
    # @userのフォロワーのプロフィールへのリンクが表示されているか
    @user.followers.each do |user|
      # <a href="/user/{:id}">...</a>
      # みたいなリンクが表示されているか
      assert_select "a[href=?]", user_path(user)
    end
  end
end