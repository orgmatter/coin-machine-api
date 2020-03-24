require 'rails_helper'

RSpec.describe Transaction, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  it { should belong_to(:user) }
  it { should belong_to(:coin) }
  it { should validate_presence_of(:transaction_type) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:coin_id) }
  it { should validate_presence_of(:user_id) }
end
