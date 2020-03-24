class AddColumnToCoin < ActiveRecord::Migration[6.0]
  def change
    add_column :coins, :count_status, :string, :after => :value
  end
end
