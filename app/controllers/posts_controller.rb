class PostsController < ApplicationController
  expose(:tread)  { Tread.published.find(params[:id]) }
  expose(:posts)  { tread.posts.published }

  def index
    respond_to do |format|
      format.json
    end
  end
end
