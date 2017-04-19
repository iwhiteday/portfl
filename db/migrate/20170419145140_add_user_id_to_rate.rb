class AddUserIdToRate < ActiveRecord::Migration[5.0]
  def change
    add_column :rates, :user_id, :integer
  end
end
