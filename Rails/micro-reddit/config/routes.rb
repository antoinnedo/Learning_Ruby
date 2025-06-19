Rails.application.routes.draw do
  root "posts#index"

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :users, only: [:new, :create, :show]
  resources :posts, only: [:index, :new, :create, :show, :destroy, :edit] do
    member do
      patch :update_status
    end
    resources :comments, only: [:create, :destroy, :edit]
  end
end
