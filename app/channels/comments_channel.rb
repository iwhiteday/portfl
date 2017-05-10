class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from stream_name
  end

  def receive(data)
    comment = Comment.create(data.fetch('message'))
    serialized = ActiveModel::SerializableResource.new(comment)

    ActionCable.server.broadcast stream_name, serialized.as_json
  end

  private

  def stream_name
    "comments_channel_#{channel_id}"
  end

  def channel_id
    params.fetch('data').fetch('modal_id')
  end

end