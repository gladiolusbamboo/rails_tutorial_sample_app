class MicropostsController < ApplicationController
  # :create :destroyメソッドを実行する前は
  # logged_in_userメソッドを実行し、ログイン済みかを確認する
  before_action :logged_in_user, only: [:create, :destroy]

  def create
  end

  def destroy
  end
end