class Transaction < ApplicationRecord

   # association
   belongs_to :user
   belongs_to :coin

   # validations
   validates_presence_of :transaction_type, :value, :coin_id, :user_id
end
