class SessionsController < ApplicationController
  # /loginにGETでアクセスすると
  # sessionコントローラーのnewメソッドが実行される
  def new
  end
  
  # /loginにPOSTでデータを送信すると
  # sessionsコントローラーのcreateメソッドが実行される
  def create
    # email情報でユーザーを特定する
    user = User.find_by(email: params[:session][:email].downcase)
    # emailに該当するuserが存在しかつパスワードが適正なら
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to user
    else
      # エラーメッセージを作成する
      # flash.nowを使うことで現在のアクションでのみ有効になる
      flash.now[:danger] = 'Invalid email/password combination'
      # /sample_app/app/views/sessions/new.html.erbを描画する
      render 'new'
    end
  end

  # /logoutにDELETEでアクセスすると
  # sessionsコントローラーのdestroyメソッドが実行される
  # （内部的にはPOSTらしい）
  def destroy
  end
end
