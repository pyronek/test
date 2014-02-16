Easyblog::Application.routes.draw do
  #authenticated :user do
  # root :to => "home#index"#, as: :authenticated_root
  #end
  #unauthenticated :user do
 #  root :to => "home#index"
 # end
root to: 'home#index'

  devise_for :users
  resources :users
  resources :posts do
    resources :comments do
      member do
        post :mark_as_not_abusive
        post :vote_up
        post :vote_down
      end
    end
    member do
      post :mark_archived
    end
  end
end
