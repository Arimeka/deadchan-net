class PostsController < ApplicationController
  expose(:tread)  { Tread.published.find(params[:id]) }

  def index
    respond_to do |format|
      format.json do
        render json: tread.posts.as_json
      end
    end
  end
end