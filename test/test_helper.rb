ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # テストでもapplication_helper内の関数を使用できるようにする
  include ApplicationHelper

  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end
end

# 統合テストの中でだけ使用するメソッドを定義するクラス
class ActionDispatch::IntegrationTest
  # テストユーザーとしてログインする
  def log_in_as(user, password: 'password', remember_me: '1')
    # POSTで/loginにログインデータを送信する
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
  
  def log_out
    delete logout_path 
  end
end
