Rails.application.routes.draw do

  resources :users do
    resources :photos do
      resources :comments
    end
  end

  resources :accounts

  devise_for :accounts, :controllers => { omniauth_callbacks: 'accounts/omniauth_callbacks'}

  post '/upload', to: 'photos#create'

  root 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  mount ActionCable.server => '/cable'
end
