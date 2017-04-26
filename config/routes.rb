Rails.application.routes.draw do

  resources :sessions

  resources :users do
    resources :photos do
      resources :comments
      resources :rates
      resources :hashtags
      collection do
        patch :update_priorities
      end
    end
    collection do
      get :search
      post :filter
    end
  end

  resources :accounts

  devise_for :accounts, :controllers => { omniauth_callbacks: 'accounts/omniauth_callbacks'}

  post '/upload', to: 'photos#create'

  root 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount ActionCable.server => '/cable'
end
