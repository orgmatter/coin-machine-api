require 'rails_helper'

RSpec.describe User, type: :model do

  it { should have_many(:coins).dependent(:destroy) }
  it { should have_many(:transactions).dependent(:destroy) }

  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:roles) }
  it { should validate_presence_of(:api_key) }
end
