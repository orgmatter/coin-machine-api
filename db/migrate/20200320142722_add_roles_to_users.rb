class AddRolesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :roles, :string, :after => :password
  end
end
