require 'securerandom'

class UsersController < ApplicationController
    before_action :auth_user, only: [:total_coins_value, :all_transactions, :user_transactions]
    before_action :set_user, only: [:get_user_withdrawals, :get_user_deposits]
    before_action :set_user_coin, only: [:show, :update, :destroy]
    before_action :set_user_total_coins, only: [:total_coins_value]
    before_action :set_user_transactions

    # get all users
    def index
        json_response(User.all)
    end

    # create a user
    def create
        api_key = SecureRandom.hex(14);
        users = User.new(:username => params[:username], :password => params[:password], :roles => params[:roles], :api_key => api_key, :admin_id => params[:admin_id]);
        if users.save!
            json_response(users, :created);
        end
    end

    # get total coins value with this route => host/users/total_coins_value?:user_id=user_id
    def total_coins_value
        json_response({:total_coins_value => @total_coins_val, :status => true, :message => 'calculated'})
    end

    # all transactions => host/users/transactions?:user_id=user_id
    def all_transactions
        json_response(Transaction.all)
    end

    # all transactions for a specific user => host/users/user_transactions?:user_id=user_id
    def user_transactions
        user_deposits = get_user_deposits
        user_withdrawals = get_user_withdrawals
       json_response({:user_transactions => @user_transactions, :user_deposits => user_deposits, :user_withdrawals => user_withdrawals})
    end


    private

    def get_user_withdrawals
        withdrawals = Transaction.where(transaction_type: 'withdrawal', user_id: @user.id) if @user
        return withdrawals
    end

    def get_user_deposits
        deposits = Transaction.where(transaction_type: 'deposit', user_id: @user.id) if @user
        return deposits
    end
end
