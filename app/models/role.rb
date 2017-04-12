class Role < ApplicationRecord
  has_many :users
  def inspect
    title
  end
end
