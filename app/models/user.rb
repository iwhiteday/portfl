class User < ApplicationRecord
  include ActiveModel::Serializers::JSON

  enum sex: {male: 1, female: 2}
  belongs_to :role
  has_many :photos, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :rates
  has_and_belongs_to_many :preferences
  has_one :account, dependent: :destroy

  after_initialize :set_defaults
  after_commit :clear_cache

  def avatar
    Photo.find(avatar_id)
  end

  def as_json(options={})
    Rails.cache.fetch(cache_key) do
      super({include: [:role, :avatar, :preferences, :photos => {include: [:hashtags, :comments]}], methods: :sex})
    end
  end

  def clear_cache
    Rails.cache.delete(cache_key)
  end

  private

  def set_defaults
    self.role ||= Role.where(title: 'user').first
    self.avatar_id ||= 1
  end

  def cache_key
    "user_#{id}"
  end
end
