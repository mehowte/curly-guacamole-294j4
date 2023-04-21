Rails.application.routes.draw do
  root 'homepage#index'
  namespace :api do
    resources :questions, only: [:create]
  end
end
