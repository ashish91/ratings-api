Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :products, only: [] do
      resources :ratings, only: [:index]
    end
  end
end
