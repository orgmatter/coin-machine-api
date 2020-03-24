require 'rails_helper'

RSpec.describe Admin, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  it { should validate_presence_of(:admin_type) }
  it { should validate_presence_of(:email) }
end
