class CreateRates < ActiveRecord::Migration[5.0]
  def change
    create_table :rates do |t|
      t.integer :value
      t.integer :photo_id
    end
  end
end
