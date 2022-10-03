Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      users: 'users/users'
    }

  resources :posts, only: [:index, :show, :create, :update, :destroy]
  resources :comments, only: [:index, :show, :create, :update, :destroy]
  resources :ratings, only: [:index, :show, :create, :update, :destroy]

  get '/current_user', to: 'current_user#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
