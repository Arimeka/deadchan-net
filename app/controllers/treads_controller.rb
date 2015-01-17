class TreadsController < ApplicationController
  include CheckPostingConcern

  expose(:board)  { Board.published.find_by(abbr: params[:abbr]) }
  expose(:entry)  { board.treads.published.find(params[:id]) }
  expose(:posts)  { entry.posts.published }
  expose(:post)   { Post.new(post_params) }

  before_action :check_ban, :verify_recaptcha!, :check_last_posting, only: :create

  def show
    redirect_to_good_slug and return if bad_slug?

    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    respond_to do |format|
      format.json do
        unless user_signed_in? || admin_signed_in?
          user = User.create
          user.remember_me!
          post.user_id = user.id
        end
        post.user_id = current_user.id if user_signed_in?
        post.request_ip = IPAddr.new(request.ip).hton
        entry.posts.push(post)
        if entry.save
          unless user_signed_in? || admin_signed_in?
            sign_in user
            render json: {app: {notice: {text: [t('msg.saved')]}, reload: true, id: post.id}}
          else
            render json: {app: {notice: {text: [t('msg.saved')]}, id: post.id}}
          end
          $redis.set("last_posting:#{current_user.id}", 1, ex: 10) if user_signed_in?
        else
          errors = post.errors.full_messages
          render json: {app: {error: {text: errors}}}
        end
      end
    end
  end

  def form
    respond_to do |format|
      format.html do
        self.post.build_image unless self.post.image
        render partial: 'form'
      end
    end
  end

  private
    def post_params
      params[:post] = set_file(params[:post], params[:file]) if params[:post] && params[:file]
      params.fetch(:post, {}).permit(:content, image_attributes: [:id, :file], video_attributes: [:id, :file])
    end

    def verify_recaptcha!
      unless user_signed_in? || admin_signed_in?
        unless verify_recaptcha(model: post)
          errors = post.errors.full_messages
          render json: {app: {error: {text: errors}}}
        end
      end
    end

    def set_file(params, file)
      if file.content_type == 'video/webm'
        params[:video_attributes] = {file: file}
      else
        params[:image_attributes] = {file: file}
      end
      params
    end
end
