class Admin < ApplicationRecord
    # validation
    validates_presence_of :admin_type, :email
end
