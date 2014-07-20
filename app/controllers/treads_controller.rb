class TreadsController < ApplicationController
  expose(:board)  { Board.published.find_by(abbr: params[:abbr]) }
  expose(:entry)  { board.treads.published.find(params[:id]) }
  expose(:posts)  { entry.posts.published }
  expose(:tread)  { board.treads.build(tread_params) }
  expose(:post)   { Post.new(post_params) }

  def create
    respond_to do |format|
      format.html do
        verify_recaptcha! unless user_signed_in? || admin_signed_in?
        if tread.save
          unless user_signed_in? || admin_signed_in?
            user = User.create
            user.remember_me!
            sign_in user
          end
          redirect_to tread_url(board.abbr, tread.id), notice: t('msg.saved')
        else
          flash.now[:error] = tread.errors.full_messages
          render :show
        end
      end
    end
  end

  private
    def tread_params
      params.fetch(:tread, {}).permit(:title, :content)
    end

    def post_params
      params.fetch(:post, {}).permit(:content)
    end

    def verify_recaptcha!
      unless verify_recaptcha
        render :show
      end
    end
end
