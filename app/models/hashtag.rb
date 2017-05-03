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

  def self.tagcloud_data
    Rails.cache.fetch(cache_key) do
      relation = Hashtag.left_joins(:photos).group(:id).order('COUNT(hashtag_id) DESC').limit(10)
      tags = relation.pluck(:tag)
      weights = relation.count.values
      tag_cloud_data = []
      (0..tags.length - 1).each { |i|
        tag_cloud_data.push({text: tags[i], weight: weights[i]})
      }
      tag_cloud_data
    end
  end

  private

  def self.cache_key
    'TAGCLOUD_DATA'
  end

  def clear_cache
    #dermo kakoe-to
    Rails.cache.delete(cache_key)
    self.photos.each do |photo|
      photo.clear_cache
    end
  end
end
