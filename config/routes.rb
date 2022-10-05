Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
    }

  resources :posts, only: [:index, :show, :create, :update, :destroy, :get_comments]
  resources :comments, only: [:index, :show, :create, :update, :destroy]
  resources :ratings, only: [:index, :show, :create, :update, :destroy]

  get '/current_user', to: 'current_user#index'
  get '/activity_feed', to: 'activity_feed#show'
  get '/get_comments_for_post', to: 'posts#get_comments_for_post'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
