require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # ユーザーデータ設定
  def setup
    @user = users(:michael)
  end

  # ユーザー一覧ページがページネーションを実装しているか
  test "index including pagination" do
    # ログイン
    log_in_as(@user)
    # GETで/usersにアクセスする
    get users_path
    # 適切なテンプレートが適用されているか
    assert_template 'users/index'
    # <dic class="pagination">...</div>
    # みたいなHTMLが上下2箇所にあるか
    assert_select 'div.pagination', count: 2
    User.paginate(page: 1).each do |user|
      # <a href="{user_path(user)}">ユーザー名</a>
      # みたいなHTMLがあるか
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end
end