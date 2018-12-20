require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    # michaelでログインする
    log_in_as(@user)
    # ルートにGETアクセス
    get root_path
    # <div class="pagination">が存在するか
    assert_select 'div.pagination'
    assert_select 'input[type=file]'

    # 無効な送信をしても反映されないか
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    # <div id="error_explanation">...</div>みたいなHTMLがあるか
    assert_select 'div#error_explanation'
    # 有効な送信が反映されるか
    content = "This micropost really ties the room together"
    # fixtures/rails.pngをテスト用にアップロードする
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    # 画像を一緒にアップロードする
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: { micropost:
                                      { content: content,
                                        picture: picture } }
    end
    # ユーザーの最初の投稿に画像データがあるか？
    # （reloadはしなくても良いようだ）
    assert @user.microposts.first.picture?
    # ルートにリダイレクトされるか
    assert_redirected_to root_url
    follow_redirect!
    # HTML全体(response.body)に投稿内容が含まれているか
    assert_match content, response.body
    # 投稿を削除する
    # <a>delete</a>みたいなHTMLが存在するか
    assert_select 'a', text: 'delete'
    # 投稿が正常に削除されるか
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:archer))
    # <a>delete</a>みたいなHTMLが存在しないか
    assert_select 'a', text: 'delete', count: 0
  end
  
  # Micropostの投稿数表示のテスト
  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    # まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A micropost")
    get root_path
    assert_match "#{other_user.microposts.count} micropost", response.body
  end
end
