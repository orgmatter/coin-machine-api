require 'rails_helper'

RSpec.describe Coin, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  it { should belong_to(:user) }
  it { should have_many(:transactions).dependent(:destroy) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:value) }
  it { should validate_presence_of(:user_id) }
end
