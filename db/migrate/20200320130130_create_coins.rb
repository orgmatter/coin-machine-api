class CreateCoins < ActiveRecord::Migration[6.0]
  def change
    create_table :coins do |t|
      t.string :name
      t.decimal :value
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
