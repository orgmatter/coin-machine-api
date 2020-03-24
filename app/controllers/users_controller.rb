require 'securerandom'

class UsersController < ApplicationController    

    # before_action :set_admin

    # get all users
    def index
        json_response(User.all)
    end

    # create a user
    def create
        api_key = SecureRandom.hex(14);
        users = User.new(:username => params[:username], :password => params[:password], :roles => params[:roles], :api_key => api_key, :admin_id => params[:admin_id]);
        # users = User.create(admin: @admin, username: params[:username], password: params[:password], roles: params[:roles], api_key: api_key);
        # users.save!
        
        if users.save!
            json_response(users, :created);
        end
    end


    private

    # def set_admin
    #     @admin = Admin.find(params[:admin_id]);
    # end
end
