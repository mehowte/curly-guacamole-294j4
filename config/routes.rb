Rails.application.routes.draw do
  root 'homepage#index'
  namespace :api do
    resources :projects, only: [] do
      resources :questions, only: [:create]
    end
    resources :questions, only: [:show] do
        member do
          post :audio
        end
      end
  end
end
