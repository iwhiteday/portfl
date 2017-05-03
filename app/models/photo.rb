class Photo < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_and_belongs_to_many :hashtags

  before_save :set_priority
  after_commit :clear_cache, ThinkingSphinx::RealTime.callback_for(:user, [:user])
  after_destroy :delete_photo_from_hosting

  def clear_cache
    user.clear_cache
  end

  def update_rating
    self.rating = rates.sum(:value).to_f / rates.length.to_f
  end

  def delete_photo_from_hosting
    unless public_id.empty?
      Cloudinary::Uploader.destroy(public_id)
    end
  end

  def self.create_from_file(file)
    response = Cloudinary::Uploader.upload(file)
    unless response.key?('url')
      render status: 500
    end
    @photo = Photo.new
    @photo.user_id = params[:user_id]
    @photo.url = response['url']
    @photo.public_id = response['public_id']
    @photo
  end

  def check_for_nudity
    resp = Unirest.get "https://sightengine-nudity-and-adult-content-detection.p.mashape.com/nudity.json?url=#{url}",
                       headers:{
                           "X-Mashape-Key" => "JDD65uYWJ3mshZ8AzHlsyJCi909Lp1E1jKLjsn9WeFFjh8MEf1",
                           "Accept" => "application/json"
                       }
    puts resp.body
    resp.body['nudity']['safe'] > 0.3
  end


  def self.get_top
    Photo.all.order(rating: :desc).limit(10)
  end

  private

  def set_priority
    self.priority ||= user.photos.length
  end
end
