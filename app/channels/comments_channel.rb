class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'comments_channel'
  end

  def receive(data)
    comment = Comment.create(data.fetch('message'))
    ActionCable.server.broadcast 'comments_channel', comment
  end
end