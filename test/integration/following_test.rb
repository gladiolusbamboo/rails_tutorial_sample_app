require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other = users(:archer)
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
  
  # HTML経由？でフォローする
  test "should follow a user the standard way" do
    # HTML経由のフォロー操作で@userのフォロー数が１増えるか
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: { followed_id: @other.id }
    end
  end
  
  # Ajax経由？でフォローする
  test "should follow a user with Ajax" do
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: { followed_id: @other.id }
    end
  end
  
  # HTML経由？でアンフォローする
  test "should unfollow a user the standard way" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      # /relationships/:id にDELETEリクエストを送る
      # コントローラー側ではparams[:id]で参照できる
      delete relationship_path(relationship)
    end
  end
  
  # Ajax経由？でアンフォローする
  test "should unfollow a user with Ajax" do
    @user.follow(@other)
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end
  
  test "feed on Home page" do
    get root_path
    @user.feed.paginate(page: 1).each do |micropost|
      # micropost.contentは平文なので'<などをエスケープしてやる必要がある
      assert_match CGI.escapeHTML(micropost.content), response.body
    end
  end
end