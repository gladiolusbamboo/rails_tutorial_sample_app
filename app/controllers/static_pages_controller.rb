class StaticPagesController < ApplicationController
  def home
    # ログイン中ならユーザーと紐付いたポストを新規作成する
    # (フォームの作成に必要)
    # /sample_app/app/views/shared/_micropost_form.html.erb
    # で参照している
    @micropost = current_user.microposts.build if logged_in?
  end

  def help
  end

  def about
  end
  
  def contact
  end
end
