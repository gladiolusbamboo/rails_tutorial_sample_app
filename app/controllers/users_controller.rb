class UsersController < ApplicationController
  # :edit :updateメソッドを実行する前は
  # logged_in_userメソッドを実行し、ログイン済みかを確認
  # さらにcorrect_userメソッドを実行し、正しいユーザーかを確認
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  # ユーザーデータ削除の前に管理者権限を確認する
  before_action :admin_user,     only: :destroy
  
  def index
    # ページネーションを使用してユーザーを取得する
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    # ユーザーに紐付いているポストを同時に表示する
    # params[:page]がない場合は最初のページを返す
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  # /usersにPOSTでアクセスしたとき(/signupのフォームからデータを送信したとき)に実行される
  def create
    # /signupから以下のようなハッシュデータが送信されてくる
    # {"utf8"=>"✓",
    #  "authenticity_token"=>"XXXXXXXXXX==",
    #  "user"=>{"name"=>"yjkym", 
    #  "email"=>"y@jk.ym", 
    #  "password"=>"[FILTERED]", 
    #  "password_confirmation"=>"[FILTERED]"},
    #  "commit"=>"Create my account"}
    
    # params[:user]でハッシュデータが取り出せる
    # @user = User.new(params[:user])    # 実装は終わっていないことに注意!
    
    # セキュリティ上、送信データの検証をしてやるべき
    # Strong Parametersというテクニックを使う
    @user = User.new(user_params)
    if @user.save
      # 登録と同時にログインさせる
      log_in @user
      # リダイレクト先で表示するメッセージを設定
      flash[:success] = "Welcome to the Sample App!"
      # 登録に成功したユーザーデータを表示する
      redirect_to user_url(@user)
    else
      # ユーザーデータ保存に失敗した場合、
      # new.html.erbを表示する（エラーメッセージ含む）
      render 'new'
    end
    
    
  end
  
  def edit
    # ユーザーデータを取得する
    @user = User.find(params[:id])
  end
  
  # ユーザーデータ編集
  def update
    @user = User.find(params[:id])
    # Strong Parametersを用いてマスアサインメント脆弱性対策をしている
    if @user.update_attributes(user_params)
      # flashに成功時メッセージを設定
      flash[:success] = "Profile updated"
      # ユーザーデータの表示へリダイレクトする
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  # ユーザーデータ削除
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  # following_user GET    /users/:id/following(.:format) users#following
  # フォロー相手一覧表示
  def following
    # 表示に必要なインスタンス変数を設定して
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    # /sample_app/app/views/users/show_follow.html.erb
    # レイアウトで表示
    render 'show_follow'
  end
  
  # followers_user GET    /users/:id/followers(.:format) users#followers
  # フォロワー一覧表示
  def followers
    # 表示に必要なインスタンス変数を設定して
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    # /sample_app/app/views/users/show_follow.html.erb
    # レイアウトで表示
    render 'show_follow'
  end
  
  private
    def user_params
      # paramsハッシュでは:user属性を必須とし、
      # 名前、メール、パスワード（確認）の属性を許可する
      # 返り値はハッシュ↓
      # {"name"=>"", "email"=>"", 
      #  "password"=>"", "password_confirmation"=>""} 
      params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
    end
    
    # ログイン済みユーザーかどうか確認
    # ログイン済みなら何も行わない
    # def logged_in_user
    #  unless logged_in?
        # ログイン後リダイレクトさせるために
        # アクセスしようとしたURLを保存しておく
        # /sample_app/app/helpers/sessions_helper.rb
        # で定義されているヘルパーメソッド
    #    store_location
    #    flash[:danger] = "Please log in."
    #    redirect_to login_url
    #  end
    #end
    
    # 正しいユーザーかどうか確認
    def correct_user
      # 編集か更新の時はparams[:id]の値をもっているので
      # 正しいユーザーかどうかを確認できる
      @user = User.find(params[:id])
      # 正しいユーザーなら何も行わない
      # 正しくないならルートへリダイレクトする
      # current_user?メソッドは
      # /sample_app/app/helpers/sessions_helper.rb
      # で定義されているヘルパーメソッド
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      # 現在のユーザーが管理者権限を持っていなければ
      # ルートパスにリダイレクトする
      redirect_to(root_url) unless current_user.admin?
    end
end
