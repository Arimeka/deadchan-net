class PostsController < ApplicationController
  expose(:tread)  { Tread.published.find(params[:id]) }

  def index
    respond_to do |format|
      format.json do
        render json: tread.posts.only(:_id, :content, :created_at, :replies).as_json.map { |m| m.select { |k,v| ['_id','content','created_at','replies'].include? k }}
      end
    end
  end
end
