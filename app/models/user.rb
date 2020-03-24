class User < ApplicationRecord

    # association 
    has_many :coins, dependent: :destroy
    has_many :transactions, dependent: :destroy

    # validations
    validates_presence_of :username, :password, :roles, :api_key
end
