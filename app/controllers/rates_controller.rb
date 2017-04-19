class RatesController < ApplicationController
  before_action :set_photo, :authenticate_account!

  def create
    rate = Rate.find_or_create_by(user: current_account.user)
    rate.photo = @photo
    rate.value = params[:rate][:value]

    if rate.save
      @photo.update_rating
      @photo.save
      render json: {}, status: 200
    else
      render json: {msg: rate.errors}, status: 500
    end

  end

  private

  def set_photo
    @photo = Photo.find(params[:photo_id])
  end
end
