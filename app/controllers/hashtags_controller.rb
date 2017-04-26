class HashtagsController < ApplicationController
  def index
    @hashtags = Hashtag.all
    render json: @hashtags
  end

  def create
    Hashtag.addHashtagToPhoto(params[:hashtag][:tag], params[:photo_id])
    render json: {}, status: 200
  end

  def destroy
    @hashtag = Hashtag.find_by(tag: params[:hashtag][:tag])

  end
end
