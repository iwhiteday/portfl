class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :avatar_id
      t.date :birth
      t.integer :weight
      t.integer :height
      t.integer :sex
      t.integer :role_id
    end
  end
end
