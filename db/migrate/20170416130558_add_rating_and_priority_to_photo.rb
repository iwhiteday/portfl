class AddRatingAndPriorityToPhoto < ActiveRecord::Migration[5.0]
  def change
    add_column :photos, :rating, :integer
    add_column :photos, :priority, :integer
  end
end
