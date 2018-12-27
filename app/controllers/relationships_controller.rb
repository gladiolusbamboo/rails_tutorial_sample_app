class RelationshipsController < ApplicationController
  # Relationshipを操作するためにはログインしていなければならない
  before_action :logged_in_user

  def create
    # paramsでフォロー先ユーザーを特定する
    @user = User.find(params[:followed_id])
    # ログイン中のユーザーでフォロー
    current_user.follow(@user)
    # 再描画のためのリダイレクト
    # redirect_to user
    # Ajaxに対応させる（ぜんぜんわからん）
    # /sample_app/app/views/relationships/create.js.erb
    # が実行されるっぽい？
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    # paramsでフォロー関係を解除するRelationshipを特定して、
    # フォローしているUserを見つけ出す
    @user = Relationship.find(params[:id]).followed
    # アンフォローする
    current_user.unfollow(@user)
    # 再描画のためのリダイレクト
    # redirect_to user
    # Ajaxに対応させる（ぜんぜんわからん）
    # /sample_app/app/views/relationships/create.js.erb
    # が実行されるっぽい？
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
