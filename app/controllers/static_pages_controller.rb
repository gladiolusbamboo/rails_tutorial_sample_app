class StaticPagesController < ApplicationController
  def home
    if logged_in?
      # ログイン中ならユーザーと紐付いたポストを新規作成する
      # (フォームの作成に必要)
      # /sample_app/app/views/shared/_micropost_form.html.erb
      # で参照している
      @micropost = current_user.microposts.build
      # これまでに投稿したMicropostを必要なだけとってきている
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end
  
  def contact
  end
end
