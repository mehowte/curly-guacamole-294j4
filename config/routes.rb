Rails.application.routes.draw do
  root 'homepage#index'
  namespace :api do
    resources :questions, only: [:show, :create] do
      member do
        post :audio
      end
    end
  end
end
