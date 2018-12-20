class MicropostsController < ApplicationController
  # :create :destroyメソッドを実行する前は
  # logged_in_userメソッドを実行し、ログイン済みかを確認する
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  # microposts POST   /microposts(.:format)     microposts#create
  def create
    # ポストを作成する
    # XXX_paramsはStrongParametersを使用するときの常套句
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
#      redirect_to root_url
      # 再描画？
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    # request.referrerは一つ前のURLを返す
    redirect_to request.referrer || root_url
  end
  
  private
    # Strong Parameters用
    def micropost_params
      # Micropostはcontentとpictureのみ変更を許可する
      params.require(:micropost).permit(:content, :picture)
    end
    
    def correct_user
      # ログイン中ユーザーとの関連付けからポストを特定する
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end