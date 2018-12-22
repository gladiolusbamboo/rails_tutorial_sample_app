require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # 実際のテストの前に実行されるメソッド
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  # @userの存在の確認
  test "should be valid" do
    assert @user.valid?
  end
  
  # 不正なnameをはじくか
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  # emailが存在しているか
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
  
  # emailの形式は正しくなっているか
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  
  # 不正な形式のメールアドレスをはじくか
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  # 重複するメールアドレスをはじくか
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    # 大文字にしてもはじくか
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  # /sample_app/app/models/user.rbのbefore_saveコールバックは動いているか
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  # パスワードに空白が含まれていないか
  test "password should be present (nonblank)" do
    # 不正なパスワードを設定して、assert_notになるか
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  # パスワードは６文字以上でなければならない  
  test "password should have a minimum length" do
    # 不正なパスワードを設定して、assert_notになるか
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
  
  # Userが削除されたときに紐付いているMicropostsが削除されるか
  test "associated microposts should be destroyed" do
    @user.save
    # userに紐付いたポストを生成する
    @user.microposts.create!(content: "Lorem ipsum")
    # Userを削除すると紐付いたポストも削除されるか
    assert_difference 'Micropost.count', -1 do
      @user.destroy
    end
  end
  
  # フォロー/アンフォローの機能確認
  test "should follow and unfollow a user" do
    # michael→archerフォローする
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    # フォロー解除
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end
end