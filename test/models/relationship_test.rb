require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  # michael→archerのフォロー関係を設定する
  def setup
    @relationship = Relationship.new(follower_id: users(:michael).id,
                                     followed_id: users(:archer).id)
  end

  # @relationshipは正しいデータか
  test "should be valid" do
    assert @relationship.valid?
  end

  # follower_id（フォローしている側）があるか
  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  # followed_id（フォローされている側）があるか
  test "should require a followed_id" do
    @relationship.followed_id = nil
    assert_not @relationship.valid?
  end
end