require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

  # Relationshipを作成しようとしたとき、
  # ログインしていなければログインページにリダイレクトされるか
  test "create should require logged-in user" do
    # ログインしていなければRelationshipは生成されない
    assert_no_difference 'Relationship.count' do
      # 本来はparamsを指定してやる必要がある
      post relationships_path
    end
    assert_redirected_to login_url
  end

  # Relationshipを削除しようとした場合
  # ログインしていなければログインページにリダイレクトされるか
  test "destroy should require logged-in user" do
    # ログインしていなければRelationshipは削除されない
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end
end
