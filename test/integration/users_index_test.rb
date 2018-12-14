require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # ユーザーデータ設定
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  # ユーザー一覧ページがページネーションを実装しているか
  test "index as admin including pagination and delete links" do
    # 管理者権限ユーザーでログイン
    log_in_as(@admin)
    # GETで/usersにアクセスする
    get users_path
    # 適切なテンプレートが適用されているか
    assert_template 'users/index'
    # <dic class="pagination">...</div>
    # みたいなHTMLが上下2箇所にあるか
    assert_select 'div.pagination', count: 2
    # 1ページめに表示されるユーザー一覧を取得する
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      # <a href={user_path(user)}>{user.name}</a>
      # みたいなHTMLが存在するか
      assert_select 'a[href=?]', user_path(user), text: user.name
      # 管理者でなければ
      unless user == @admin
        # deleteリンクが表示されているか
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    # ユーザーを削除できるか
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
end