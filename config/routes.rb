Dixit::Application.routes.draw do
  require 'sidekiq/web'

  mount Sidekiq::Web => '/sidekiq'

  resources :users,
    controller: 'users',
    only: Clearance.configuration.user_actions do
      resource :password,
        controller: 'clearance/passwords',
        only: [:create, :edit, :update]
    end

  resources :friendships, path: 'friends', only: [:index, :create, :destroy]
  resources :games, only: [:new, :create, :show] do
    resource :invite, only: [:new, :destroy], path_names: {new: ''} do
      get '/accept' => 'invites#accept', as: 'accept'
      get '/deny' => 'invites#deny', as: 'deny'
      get '/pending' => 'invites#pending', as: 'pending'
      post '/send_invites' => 'invites#send_invites', as: 'send'
      post '/(:friend_id)' => 'invites#create', as: 'new'
    end
    resources :rounds, only: [:show, :index] do
      post '/storypanel' => 'storypanels#create', as: 'storypanel'
      post '/picture' => 'submitted_pictures#update', as: 'picture'
      post '/vote' => 'rounds#vote', as: 'vote'
    end
  end


  get '/session', to: redirect('/sign_in')

  root to: 'games#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
