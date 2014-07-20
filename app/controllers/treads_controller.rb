class TreadsController < ApplicationController
  expose(:board)  { Board.published.find_by(abbr: params[:abbr]) }
  expose(:entry)  { board.treads.published.find(params[:id]) }
  expose(:posts)  { entry.posts.published }
  expose(:post)   { Post.new(post_params) }

  def create
    respond_to do |format|
      if (user_signed_in? || admin_signed_in?) && request.xhr?
        format.json do
          entry.posts.push(post)
          if entry.save
            render json: {app: {notice: {text: t('msg.saved')}, redirect: tread_url(board.abbr, entry.id, {anchor: post.id})}}
          else
            errors = post.errors.full_messages
            render json: {app: {error: {text: errors}}}
          end
        end
      else
        format.html do
          if verify_recaptcha
            entry.posts.push(post)
            if entry.save
              user = User.create
              user.remember_me!
              sign_in user
              redirect_to tread_url(board.abbr, entry.id, {anchor: post.id}), notice: t('msg.saved')
            else
              flash.now[:error] = post.errors.full_messages
              render :show
            end
          else
            render :show
          end
        end
      end
    end
  end

  private
    def post_params
      params.fetch(:post, {}).permit(:content)      
    end
end
