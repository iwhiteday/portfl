class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :birth, :weight, :height, :sex, :role, :avatar, :preferences
  has_many :photos

  def sex
    User.human_enum_name(:sex, object.sex)
  end
end
