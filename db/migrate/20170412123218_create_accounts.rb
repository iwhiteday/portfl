class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :email
      t.string :password
      t.string :provider
      t.string :uid
      t.integer :user_id

      t.timestamps
    end
  end
end
