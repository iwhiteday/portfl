 class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: { comment: @comment }, status: 200
    else
      render json: { errors: @comment.errors, msg: @comment.errors.full_messages.join(', ')}, status: 422
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:text, :user_id, :photo_id)
    end
end
