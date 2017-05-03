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

  #gotta fix this
  def as_json(options={})
    Rails.cache.fetch(cache_key) do
      super({include: [:role, :avatar, :preferences, :photos => {include: [:hashtags, :comments]}], methods: :sex})
    end
  end

  def clear_cache
    Rails.cache.delete(cache_key)
  end

  # search engine
  def photo_comments
    res = ''
    photos.each do |photo|
      res += photo.comments.pluck(:text).join(' ') + ' '
    end
    res
  end

  # search engine
  def photo_tags
    res = ''
    photos.each do |photo|
      res += photo.hashtags.pluck(:tag).join(' ') + ' '
    end
    res
  end

  def self.filter(query, params)
    users = User.search query, star: true, limit: 35, rank_mode: :bm25, with: create_search_params(params)
    filter_by_preferences(users, params['preferences'])
  end

  private

  def set_defaults
    self.role ||= Role.find_by(title: 'user')
    self.avatar_id ||= 1
  end

  def cache_key
    "user_#{id}"
  end

  def self.create_search_params(params)
    searchParams = {
        height: params['height']['min']..params['height']['max'],
        weight: params['weight']['min']..params['weight']['max'],
        birth: Time.new(Time.now.year - params['age']['max'])..Time.new(Time.now.year - params['age']['min'])
    }
    if params['sex']
      searchParams['sex'] = params['sex']
    end
    searchParams
  end

  def self.read_preferences(prefs)
    result = []
    unless prefs.nil?
      prefs.keys.each do |key|
        if prefs[key]
          result.push key
        end
      end
    end
    result
  end

  def self.filter_by_preferences(users, parametersPreferences)
    result = []
    preferences = read_preferences(parametersPreferences)
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
end
