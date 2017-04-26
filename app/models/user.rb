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

  def photo_comments
    res = ''
    photos.each do |photo|
      res += photo.comments.pluck(:text).join(' ') + ' '
    end
    res
  end

  def photo_tags
    res = ''
    photos.each do |photo|
      res += photo.hashtags.pluck(:tag).join(' ') + ' '
    end
    res
  end

  def self.filter(params)
    users = User.where(height: params['height']['min']..params['height']['max'], weight: params['weight']['min']..params['weight']['max'], birth: Time.new(Time.now.year - params['age']['max'])..Time.new(Time.now.year - params['age']['min']), sex: params['sex'])
    result = []
    preferences = read_preferences(params['preferences'])
    if preferences.empty?
      result = users
    else
      preferences.each do |preference|
        users.each do |user|
          if user.preferences.pluck(:value).include?(preference)
            unless result.include?(user)
              result.push user
            end
          end
        end
      end
    end
    result
  end

  private

  def set_defaults
    self.role ||= Role.find_by(title: 'user')
    self.avatar_id ||= 1
  end

  def cache_key
    "user_#{id}"
  end

  def self.read_preferences(prefs)
    result = []
    prefs.keys.each do |key|
      if prefs[key]
        result.push key
      end
    end
    result
  end
end
