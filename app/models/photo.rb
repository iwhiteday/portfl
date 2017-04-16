class Photo < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :hashtags

  before_save :set_priority
  after_commit :clear_cache
  after_destroy :delete_photo_from_hosting

  def clear_cache
    user.clear_cache
  end

  private

  def set_priority
    self.priority ||= user.photos.length
  end

  def delete_photo_from_hosting
    unless public_id.empty?
      Cloudinary::Uploader.destroy(public_id)
    end
  end
end
