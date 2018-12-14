require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # 適当なユーザーとポストを作成しておく
  def setup
    @user = users(:michael)
    # このコードは慣習的に正しくない
    @micropost = Micropost.new(content: "Lorem ipsum", user_id: @user.id)
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
end