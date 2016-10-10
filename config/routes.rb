Rails.application.routes.draw do
  resources :talk_preferences, only: [:index, :show, :create, :update]
  root to: 'home#index'
  resource :summary, only: :show
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
