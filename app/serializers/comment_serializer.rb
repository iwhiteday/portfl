class CommentSerializer < ActiveModel::Serializer
  attributes :id, :text, :photo_id, :user_id, :user_name

  def user_name
    object.user.name
  end

end
