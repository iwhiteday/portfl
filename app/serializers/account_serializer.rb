class AccountSerializer < ActiveModel::Serializer
  attributes :id, :email, :user_id, :role, :user_name

  def user_name
    object.user.name
  end

  def role
    object.user.role.title
  end
end
