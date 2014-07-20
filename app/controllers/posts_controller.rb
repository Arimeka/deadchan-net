class PostsController < ApplicationController
  expose(:board)  { Board.published.find_by(abbr: params[:abbr]) }
  expose(:tread)  { board.treads.published.find(params[:id]) }
  expose(:post)   { Post.new(post_params) }

  def create
    respond_to do |format|
      if (user_signed_in? || admin_signed_in?) && request.xhr?
        format.json do
          tread.posts.push(post)
          if tread.save
            render json: {app: {notice: {text: [t('msg.saved')]}}}
          else
            errors = post.errors.full_messages
            render json: {app: {error: {text: errors}}}
          end
        end
      else
        format.html do
          if verify_recaptcha
            tread.posts.push(post)
            if tread.save
              user = User.create
              user.remember_me!
              sign_in user
              redirect_to tread_url(board.abbr, tread.id, {anchor: post.id}), notice: t('msg.saved')
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

  def index
    tread = Tread.published.find(params[:id])
    respond_to do |format|
      format.json do
        render json: tread.posts.as_json
      end
    end
  end

  private
    def post_params
      params.fetch(:post, {}).permit(:content)
    end
end