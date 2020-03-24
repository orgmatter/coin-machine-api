class CreateAdmins < ActiveRecord::Migration[6.0]
  def change
    create_table :admins do |t|
      t.string :username
      t.string :password
      t.string :admin_type
      t.string :email

      t.timestamps
    end
  end
end
