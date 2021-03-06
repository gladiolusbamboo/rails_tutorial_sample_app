module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    # ブラウザ内の一時cookiesに暗号化済みのユーザーIDを作成する
    # また、session[:user_id]で元のユーザーIDを取り出せる
    # ただしブラウザを閉じると有効期限が終了する
    session[:user_id] = user.id
  end
  
  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    # cookiesに:user_idの値が存在するか
    if session[:user_id]
      # find_byはユーザーが存在しない場合nilを返す
      # ↓は@current_user = 
      #             @current_user || User.find_by(id: session[:user_id])
      # と同じ
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    # cookiesのユーザーIDを削除する
    session.delete(:user_id)
    # 現在のユーザーをリセットする
    @current_user = nil
  end
  
  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end
  
  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    # sessionに:forwarding_urlの値があればそのURLにリダイレクトする
    # なければ引数のURLにリダイレクトする
    redirect_to(session[:forwarding_url] || default)
    # sessionから:forwarding_urlの値を削除しておく
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLをsessionに保存しておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
