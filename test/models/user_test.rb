require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # 実際のテストの前に実行されるメソッド
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end

  # 正当性の確認
  test "should be valid" do
    assert @user.valid?
  end
  
  # 不正なnameをはじくか
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  # 不正なemailをはじくか
  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end
  
  # 51文字以上のnameをはじくか
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  
  # 255文字以上のemailをはじくか
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end
end