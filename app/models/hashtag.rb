class Hashtag < ApplicationRecord
  has_and_belongs_to_many :photos
  after_commit :clear_cache

  def self.addHashtagToPhoto(tag, photo_id)
    Hashtag.transaction do
      @hashtag = Hashtag.find_or_create_by(tag: tag)
      @photo = Photo.find(photo_id)
      @photo.hashtags << @hashtag
      @photo.save
    end
  end

  private

  def clear_cache
    #dermo kakoe-to
    self.photos.each do |photo|
      photo.clear_cache
    end
  end
end
