require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @micropost = microposts(:orange)
  end

  # ログインしていない状態で投稿しようとしたときに
  # ログインページにリダイレクトするか
  test "should redirect create when not logged in" do
    # ログインせずに投稿しようとしても
    # 投稿数が変わらないか
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    # ログインページにリダイレクトするか
    assert_redirected_to login_url
  end

  # ログインしていない状態で投稿を削除しようとしたときに
  # ログインページにリダイレクトされるか
  test "should redirect destroy when not logged in" do
    # ログインせずに削除しようとしても
    # 投稿数が変わらないか
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    # ログインページにリダイレクトするか
    assert_redirected_to login_url
  end
  
  # 異なるユーザーが投稿したポストを削除しようとしたときに
  # ルートへリダイレクトされるか
  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end
end