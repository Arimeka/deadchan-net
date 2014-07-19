class TreadsController < ApplicationController
  expose(:board)  { Board.published.find_by(abbr: params[:abbr]) }
  expose(:tread)  { board.treads.published.find(params[:id]) }
  expose(:posts)  { tread.posts.published }
  expose(:post)   { Post.new(post_params) }

  def create
    respond_to do |format|
      format.json do
        post.content = markdown(post.content)
        tread.posts.push(post)        
        if tread.save
          render json: {app: {notice: {text: t('msg.saved')}, redirect: tread_url(board.abbr, tread.id, {anchor: post.id})}}
        else
          errors = post.errors.full_messages
          render json: {app: {error: {text: errors}}}
        end
      end
    end
  end

  private
    def post_params
      params.fetch(:post, {}).permit(:content)      
    end
end
