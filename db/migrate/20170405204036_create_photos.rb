class CreatePhotos < ActiveRecord::Migration[5.0]
  def change
    create_table :photos do |t|
      t.string :url
      t.integer :user_id
      t.string :public_id

      t.timestamps
    end
  end
end
