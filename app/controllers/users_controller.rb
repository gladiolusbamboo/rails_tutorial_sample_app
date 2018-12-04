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
      # 保存の成功をここで扱う。
    else
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
