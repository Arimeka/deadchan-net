class TreadsController < ApplicationController
  expose(:board)  { Board.published.find_by(abbr: params[:abbr]) }
  expose(:tread)  { board.treads.published.find_by(nuid: params[:nuid]) }
  expose(:posts)  { tread.posts.published }
  expose(:post)   { Post.new(post_params) }

  def show
  end

  def create
    respond_to do |format|
      format.json do
        post.content = markdown(post.content)
        tread.sequence += 1
        post.nuid = tread.sequence
        tread.posts.push(post)        
        if tread.save
          render json: {app: {notice: {text: t('msg.saved')}, redirect: tread_url(board.abbr, tread.nuid, {anchor: post.nuid})}}
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
