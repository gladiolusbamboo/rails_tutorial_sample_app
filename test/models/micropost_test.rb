require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # 適当なユーザーとポストを作成しておく
  def setup
    @user = users(:michael)
    # fixturesで生成したダミーのポストを紐付ける
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end
  
  test "should be valid" do
    assert @micropost.valid?
  end

  # ユーザーIDは必須
  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  
  # ポストは内容が必要
  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  # ポストは140文字以内とする
  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  # 最新の投稿が一番最初に来ているか
  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
