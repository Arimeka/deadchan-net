class PostsController < ApplicationController
  expose(:tread)  { Tread.published.find(params[:id]) }

  def index
    respond_to do |format|
      format.json do
        render json: tread.get_posts
      end
    end
  end
end
