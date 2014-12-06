class PostsController < ApplicationController
  expose(:tread)  { Tread.published.find(params[:id]) }
  expose(:posts)  { tread.posts.published }
  expose(:post)   { Tread.published.find(params[:tread_id]).posts.published.find(params[:id]) }

  def index
    respond_to do |format|
      format.json
    end
  end

  def show
    respond_to do |format|
      format.json
    end
  end
end
