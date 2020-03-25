class AddIndexToColumn < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :api_key, :unique => true
  end
end
