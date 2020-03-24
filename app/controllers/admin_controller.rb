class AdminController < ApplicationController

    def index
        index_admin = Admin.all
        json_response(index_admin, :created)
    end

    def create
        create_admin = Admin.new(:admin_type => params[:admin_type], :email => params[:email])
        if create_admin.save!
            json_response(create_admin, :created)
        end
        # if create_admin.save!
        #     json_response(create_admin, :created)
        # end
    end

    def update
        return false
    end

    def show
        return false
    end

    def destroy
        return false
    end
end
