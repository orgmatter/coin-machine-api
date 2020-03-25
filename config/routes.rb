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

  # get '/users/:user_id/total_coins_value' => 'coins#total_coins_value', as: :users_total_coins_value
  # get '/users/:user_id/user_transactions' => 'transactions#user_transactions', as: :users_user_transaction
  # get '/users/:user_id/transactions' => 'transactions#all_transactions', as: :users_transactions
end
