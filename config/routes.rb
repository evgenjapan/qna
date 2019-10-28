Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true, only: [:create, :update, :destroy] do
      member do
        post :best
      end
    end
  end

  root to: 'questions#index'
end
