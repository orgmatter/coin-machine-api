module BeforeActions

    def set_user
        @user = User.find(params[:user_id])
    end

    def set_user_coin
        if params[:coin_id]
            @user_coin = @user.coins.find(params[:coin_id]) if @user
        end
    end

    def set_user_total_coins
        @total_coins_val = @user.coins.sum(:value)
    end

    # set all transactions for a specific user
    def set_user_transactions
        @user_transactions = @user.transactions.where(user_id: @user.id) if @user
    end

    def check_user
        user_id = params[:user_id]
        @user ||= User.find_by(id: user_id, api_key: request.headers['bearer']) if (user_id && request.headers['bearer'])
    end

    def auth_user
        json_response({:message => 'not authorized', :status => false, :user => @user}, :not_found) unless check_user
    end
end