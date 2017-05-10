class User < ApplicationRecord

  enum sex: {male: 1, female: 2, agender: 3, androgyne: 4, bigender: 5,
            genderfluid: 6, genderqueer: 7, intersex: 8, neither: 9,
            trans: 10}
  belongs_to :role
  has_many :photos, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :rates
  has_and_belongs_to_many :preferences
  has_one :account, dependent: :destroy

  after_initialize :set_defaults
  after_commit :clear_cache, ThinkingSphinx::RealTime.callback_for(:user)

  def avatar
    Photo.find(avatar_id)
  end

  def self.get_sex_value_by_key(i)
    User.sexes.find {|obj| obj[1] == i}.first
  end

  def update_preferences(preferences)
    self.preferences = []
    preferences.each do |pref|
      self.preferences << Preference.find(pref[:id])
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
    searchParams = {}
    if params['height']
      searchParams['height'] = params['height']['min']..params['height']['max']
    end
    if params['weight']
      searchParams['weight'] = params['weight']['min']..params['weight']['max']
    end
    if params['age']
      searchParams['birth'] = Time.new(Time.now.year - params['age']['max'])..Time.new(Time.now.year - params['age']['min'])
    end
    if params['sex']
      searchParams['sex'] = User.get_sex_value_by_key(params['sex']['value'].to_i)
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
