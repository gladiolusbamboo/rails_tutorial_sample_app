class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    # ログイン済みユーザーかどうか確認
    # ログイン済みなら何も行わない
    def logged_in_user
      unless logged_in?
        # ログイン後リダイレクトさせるために
        # アクセスしようとしたURLを保存しておく
        # /sample_app/app/helpers/sessions_helper.rb
        # で定義されているヘルパーメソッド
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
