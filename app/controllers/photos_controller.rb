class PhotosController < ApplicationController
  before_action :set_photos, except: :destroy
  skip_before_action :verify_authenticity_token, only: [:create, :destroy, :update]

  def index
    render json: @photos
  end

  def show
    render json: @photos.find(params[:id])
  end

  def create
    file = params[:file]
    @photo = Photo.create_from_file(file)
    if @photo.check_for_nudity
      if @photo.save
        render json: {response: @photo}, status: 200
      else
        render json: {msg: @photo.errors.full_messages.join(', ') }, status: 500
      end
    else
      @photo.delete_photo_from_hosting
      render json: {msg: 'Nudity detected'}, status: 500
    end
  end

  def destroy
    @photo = Photo.find(params[id])
    if @photo.destroy
      render status: 200
    else
      render status: 500
    end
  end

  def update
  end

  def update_priorities
    Photo.transaction do
      params.require(:photos).each do |photo|
        @photo = Photo.find(photo[:id])
        @photo.priority = photo[:priority]
        @photo.save
      end
    end
    render json: {}, status: 200
  end

  private

  def set_photos
    @photos = Photo.where(user_id: params[:user_id]).order(:priority)
  end
end
