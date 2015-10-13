Rails.application.routes.draw do
  resources :talk_preferences, only: [:index, :show, :create, :update]
  root to: 'home#index'
  get 'ratings' => 'home#ratings'
  get 'export' => 'home#export'
end
