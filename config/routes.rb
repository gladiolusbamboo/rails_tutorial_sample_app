Rails.application.routes.draw do
  # /にGETでアクセスするとstatic_pagesコントローラーのhomeメソッドを実行し、
  # 対応するViewで描画する
  root 'static_pages#home'

  # それぞれのURLにGETでアクセスすると
  # 対応するコントローラーのメソッドを実行し、
  # 対応するViewで描画する
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
end
