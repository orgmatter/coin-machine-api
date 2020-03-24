class CoinsController < ApplicationController
    before_action :auth_user
    before_action :set_user
    before_action :set_user_coin, only: [:show, :update, :destroy]
    before_action :set_user_total_coins

    # create new coin
    def index
        json_response(@user.coins)
    end

    def create
        # coin = @user.coins.new(:name => params[:name], :value => params)
        coin = @user.coins.new(coin_params);
        coin.save!
        json_response(coin, :created)
    end

    def show
        json_response(@coin)
    end

    def update
        @coin.update(coin_params)
        json_response({:status => true, :message => 'updated'})
    end

    def destroy
        @coin.destroy
        head :no_content
        json_response({:status => true, :message => 'deleted'})
    end

    def total_coins_value
        # total_coins_val = set_user_total_coins
        json_response({:total_coins_value => @total_coins_val, :status => true, :message => 'calculated'})
    end


    
    private

    def coin_params
        params.permit(:name, :value)
    end

    def set_user
        @user = User.find(params[:user_id])
    end

    def set_user_coin
        @coin = @user.coins.find_by!(id: params[:id]) if @user
    end

    def set_user_total_coins
        @total_coins_val = @user.coins.sum(:value)
    end

    def check_user
        user_id = params[:user_id]
        @user ||= User.find_by(id: user_id, api_key: request.headers['bearer']) if (user_id && request.headers['bearer'])
    end

    def auth_user
        json_response({:message => 'not authorized', :status => false, :user => @user}, :not_found) unless check_user
    end

end
