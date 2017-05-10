class PhotoSerializer < ActiveModel::Serializer
  attributes :id, :url, :rating, :priority, :created_at, :hashtags
  has_many :comments

end
