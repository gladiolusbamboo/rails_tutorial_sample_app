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
  # resources :users
  
  # following_user GET    /users/:id/following(.:format) users#following
  # followers_user GET    /users/:id/followers(.:format) users#followers
  #         users GET    /users(.:format)               users#index
  #               POST   /users(.:format)               users#create
  #       new_user GET    /users/new(.:format)           users#new
  #     edit_user GET    /users/:id/edit(.:format)      users#edit
  #           user GET    /users/:id(.:format)           users#show
  #               PATCH  /users/:id(.:format)           users#update
  #               PUT    /users/:id(.:format)           users#update
  #               DELETE /users/:id(.:format)           users#destroy
  
  # resources :usersに加えて
  # /users/:idに対してアクションを起こすルーティングを設定できる
  # /users/に対するアクションはcollectionメソッドで設定できる
  resources :users do
    member do
      get :following, :followers
    end
    # collection do
    #   get :tigers
    # end
  end
  
  
  # microposts POST   /microposts(.:format)     microposts#create
  # micropost DELETE /microposts/:id(.:format) microposts#destroy
  resources :microposts, only: [:create, :destroy]
  
  # フォローとアンフォローに対応している
  # relationships POST   /relationships(.:format)       relationships#create
  # relationship DELETE /relationships/:id(.:format)   relationships#destroy
  resources :relationships,       only: [:create, :destroy]
end
