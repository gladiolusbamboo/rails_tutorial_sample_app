class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
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
end
