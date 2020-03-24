class TransactionsController < ApplicationController
    before_action :auth_user
    before_action :set_user
    before_action :set_user_transactions
    before_action :set_user_coin

    # all transactions => localhost:3000/users/:user_id/transactions
    def all_transactions
        json_response(Transaction.all)
    end

    # all transactions for a specific user => localhost:3000/users/:user_id/user_transactions
    def user_transactions
        user_deposits = get_user_deposits
        user_withdrawals = get_user_withdrawals
       json_response({:user_transactions => @user_transactions, :user_deposits => user_deposits, :user_withdrawals => user_withdrawals})
    end

    # all transactions for a specific coin => localhost:3000/users/:user_id/coins/:coin_id/transactions
    def index
        user_coin_transactions = get_user_coin_transactions
        if user_coin_transactions
            json_response(user_coin_transactions)
        else 
            json_response({:status => false, :message => 'no transaction'})
        end
    end

    # create new transactions => localhost:3000/users/:user_id/coins/:coin_id/transactions
    def create
        
        if params[:type] == 'deposit'
            transaction = Transaction.create(user: @user, coin: @user_coin, transaction_type: params[:transaction_type], value: params[:value])
            
            transaction.update(:transaction_type => 'deposit')
            increment_coin(params[:value])
            deposited_coin = get_deposited_coin(transaction)
            json_response({:transaction => transaction, :deposited_coin => deposited_coin, :user => @user}, :created)
       
        elsif params[:type] == 'withdraw'
           
            withdraw_status = decrement_coin(params[:value])
            if withdraw_status == true
                transaction = Transaction.create(user: @user, coin: @user_coin, transaction_type: params[:transaction_type], value: params[:value])
                transaction.update(:transaction_type => 'withdrawal')
                deposited_coin = get_deposited_coin(transaction)
                json_response({:transaction => transaction, :deposited_coin => deposited_coin, :user => @user}, :created)
            else
                json_response({:message => 'coin value too low'}, :created)
            end
        end
    end


    private

    def transaction_params
        params.permit(:transaction_type)
    end

    def set_user
        @user = User.find(params[:user_id])
    end

    # set the coin for a specific user transaction
    def set_user_coin
        if params[:coin_id]
            @user_coin = @user.coins.find(params[:coin_id]) if @user
        end
    end

    # set all transactions for a specific user
    def set_user_transactions
        @user_transactions = @user.transactions.where(user_id: @user.id) if @user
    end

    # all transaction for a specific coin
    def get_user_coin_transactions
        user_coin_transactions = Transaction.where(user_id: @user.id, coin_id: @user_coin.id) if @user
        return user_coin_transactions;
    end

    # the deposited coin function
    def get_deposited_coin(transaction)
        deposited_coin = @user.coins.find(transaction.coin_id) if @user
        return deposited_coin
    end

    # increment the coin model (deposit)
    def increment_coin(transaction_coin_value)
        system_coin_value = @user_coin.value
        increment_value = system_coin_value.to_i + transaction_coin_value.to_i
        @user_coin.update(value: increment_value)
        if ((system_coin_value > 10) || (system_coin_value > transaction_coin_value.to_i))
            # return false
            @user_coin.update(count_status: 'high')
        end
    end

    # decrement the coin model (withdraw)
    def decrement_coin(transaction_coin_value)
        empty = ''
        system_coin_value = @user_coin.value
        if transaction_coin_value.to_i >= system_coin_value
            # return false

            if system_coin_value  <= 10
                @user_coin.update(value: system_coin_value, count_status: 'low')
                admin_user = User.find_by(roles: 'Administrator')
                if admin_user.roles == 'Administrator'
                    puts admin_user.admin_id
                    mail = UserMailer.admin_email(admin_user.admin_id, @user_coin.name, @user_coin.value, @user_coin.count_status)
                    mail.deliver_now
                    # mail.deliver_later!
                end
                return false

            end
        elsif system_coin_value > transaction_coin_value.to_i 
            # return false
            coin_bal = system_coin_value - transaction_coin_value.to_i

            if coin_bal <= 10
                @user_coin.update(value: coin_bal, count_status: 'low')
                admin_user = User.find_by(roles: 'Administrator')
                if admin_user.roles == 'Administrator'
                    puts admin_user.admin_id
                    mail = UserMailer.admin_email(admin_user.admin_id, @user_coin.name, @user_coin.value, @user_coin.count_status)
                    mail.deliver_now
                    # mail.deliver_later!
                end
                return false
                

            elsif coin_bal > transaction_coin_value.to_i
                decrement_value = system_coin_value.to_i - transaction_coin_value.to_i
                @user_coin.update(value: decrement_value, count_status: 'low')
                return true
            end
        else
            return false
        end
    end

    def get_user_withdrawals
        withdrawals = Transaction.where(transaction_type: 'withdrawal', user_id: @user.id) if @user
        return withdrawals
    end

    def get_user_deposits
        deposits = Transaction.where(transaction_type: 'deposit', user_id: @user.id) if @user
        return deposits
    end

    def check_user
        user_id = params[:user_id]
        @user ||= User.find_by(id: user_id, api_key: request.headers['bearer']) if (user_id && request.headers['bearer'])
    end

    def auth_user
        json_response({:message => 'not authorized', :status => false, :user => @user}, :not_found) unless check_user
    end

end
