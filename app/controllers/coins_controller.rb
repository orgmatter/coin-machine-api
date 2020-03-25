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
    
    private

    def coin_params
        params.permit(:name, :value)
    end

end
