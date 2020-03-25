class TransactionsController < ApplicationController
    before_action :auth_user
    before_action :set_user
    before_action :set_user_coin

    # all transactions for a specific coin => host/users/:user_id/coins/:coin_id/transactions
    def index
        user_coin_transactions = get_user_coin_transactions
        if user_coin_transactions
            json_response(user_coin_transactions)
        else 
            json_response({:status => false, :message => 'no transaction'})
        end
    end

    # create new transactions => host/users/:user_id/coins/:coin_id/transactions
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
            @user_coin.update(count_status: 'high')
        end
    end

    # decrement the coin model (withdraw)
    def decrement_coin(transaction_coin_value)
        empty = ''
        system_coin_value = @user_coin.value
        if transaction_coin_value.to_i >= system_coin_value

            if system_coin_value  <= 10
                @user_coin.update(value: system_coin_value, count_status: 'low')
                admin_user = User.find_by(roles: 'Administrator')
                if admin_user.roles == 'Administrator'
                    mail = UserMailer.admin_email(admin_user.admin_id, @user_coin.name, @user_coin.value, @user_coin.count_status)
                    mail.deliver_now
                    # mail.deliver_later!
                end
                return false

            end
        elsif system_coin_value > transaction_coin_value.to_i
            coin_bal = system_coin_value - transaction_coin_value.to_i

            if coin_bal <= 10
                @user_coin.update(value: coin_bal, count_status: 'low')
                admin_user = User.find_by(roles: 'Administrator')
                if admin_user.roles == 'Administrator'
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

end
