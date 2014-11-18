class TreadsController < ApplicationController
  include CheckPostingConcern

  expose(:board)  { Board.published.find_by(abbr: params[:abbr]) }
  expose(:entry)  { board.treads.published.find(params[:id]) }
  expose(:posts)  { entry.posts.published }
  expose(:post)   { Post.new(post_params) }

  before_action :check_ban, :verify_recaptcha!, :check_last_posting, only: :create

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
          $redis.set("last_posting:#{current_user.id}", 1, ex: 10)
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
        render partial: 'form'
      end
    end
  end

  private
    def post_params
      params.fetch(:post, {}).permit(:content)
    end

    def verify_recaptcha!
      unless user_signed_in? || admin_signed_in?
        unless verify_recaptcha(model: post)
          errors = post.errors.full_messages
          render json: {app: {error: {text: errors}}}
        end
      end
    end
end
