Rails.application.routes.draw do
  get 'users/new'

  # /にGETでアクセスするとstatic_pagesコントローラーのhomeメソッドを実行し、
  # 対応するViewで描画する
  root 'static_pages#home'

  # それぞれのURLにGETでアクセスすると
  # 対応するコントローラーのメソッドを実行し、
  # 対応するViewで描画する
  # get 'static_pages/home'
  # get 'static_pages/help'
  # get 'static_pages/about'
  # get 'static_pages/contact'

  # それぞれのURLにGETでアクセスすると
  # 指定したコントローラーのメソッドを実行し、
  # 対応するViewで描画する
  # ↓のように指定することで名前付きルート（help_path,help_urlなど）が使用できるようになる
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  
  # ↓の指定でsignup_path,signup_urlなどの名前付きルートが使用できる
  get  '/signup', to: 'users#new'
end
