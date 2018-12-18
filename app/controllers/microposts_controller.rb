class MicropostsController < ApplicationController
  # :create :destroyメソッドを実行する前は
  # logged_in_userメソッドを実行し、ログイン済みかを確認する
  before_action :logged_in_user, only: [:create, :destroy]

  # microposts POST   /microposts(.:format)     microposts#create
  def create
    # ポストを作成する
    # XXX_paramsはStrongParametersを使用するときの常套句
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # 再描画？
      render 'static_pages/home'
    end
  end

  def destroy
  end
  
  private
    # Strong Parameters用
    def micropost_params
      # Micropostはcontentのみ変更を許可する
      params.require(:micropost).permit(:content)
    end
end