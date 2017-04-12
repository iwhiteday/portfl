class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :photo
  after_commit :clear_cache

  private

  def clear_cache
    photo.clear_cache
  end
end
