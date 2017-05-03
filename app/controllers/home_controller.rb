class HomeController < ApplicationController
  def index
  end

  def index_json
    render json: {tags: Hashtag.tagcloud_data, photos: Photo.get_top}
  end
end
