class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :type
      t.decimal :value
      t.references :user, null: false, foreign_key: true
      t.references :coin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
