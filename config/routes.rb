Rails.application.routes.draw do
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
  # /signupにpostでユーザーデータを送ると
  # usersコントローラーのcreateメソッドが実行される
  post '/signup',  to: 'users#create'
  
  # /loginにGETでアクセスすると
  # sessionコントローラーのnewメソッドが実行される
  get    '/login',   to: 'sessions#new'
  # /loginにPOSTでデータを送信すると
  # sessionsコントローラーのcreateメソッドが実行される
  post   '/login',   to: 'sessions#create'
  # /logoutにDELETEでアクセスすると
  # sessionsコントローラーのdestroyメソッドが実行される
  # （内部的にはPOSTらしい）
  delete '/logout',  to: 'sessions#destroy'
  
  # resourcesで多数の名前付きルートが使えるようになる
  # RESTfulなUsersリソースで必要となるすべてのアクションが利用できるようになる
  # (index,show,new,create,edit,update,destroy)
  resources :users
  
  # microposts POST   /microposts(.:format)     microposts#create
  # micropost DELETE /microposts/:id(.:format) microposts#destroy
  resources :microposts, only: [:create, :destroy]
end
