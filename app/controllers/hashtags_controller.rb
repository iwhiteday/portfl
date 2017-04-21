class HashtagsController < ApplicationController
  def index
    @hashtags = Hashtag.all
    render json: @hashtags
  end

  def create
    @hashtag = Hashtag.find_or_create_by(tag: params[:hashtag][:tag])
    @photo = Photo.find(params[:photo_id])
    @photo.hashtags << @hashtag
  end

  def destroy
    @hashtag = Hashtag.find_by(tag: params[:hashtag][:tag])

  end
end
