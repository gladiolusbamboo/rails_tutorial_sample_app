module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    # ブラウザ内の一時cookiesに暗号化済みのユーザーIDを作成する
    # また、session[:user_id]で取り出せる
    # ただしブラウザを閉じると有効期限が終了する
    session[:user_id] = user.id
  end
end
