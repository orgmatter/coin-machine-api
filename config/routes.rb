Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users do
    collection do
      get :total_coins_value
    end
    collection do
      get :user_transactions
      get :transactions
    end
    resources :coins do
      resources :transactions
    end
  end

  resources :admin
end
