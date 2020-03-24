class Coin < ApplicationRecord

  # association
  belongs_to :user
  has_many :transactions, dependent: :destroy

  # validations
  validates_presence_of :name, :value, :user_id
end
