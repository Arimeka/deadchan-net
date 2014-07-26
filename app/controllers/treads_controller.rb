class TreadsController < ApplicationController
  expose(:board)  { Board.published.find_by(abbr: params[:abbr]) }
  expose(:entry)  { board.treads.published.find(params[:id]) }
  expose(:posts)  { entry.posts.published }
  expose(:post)   { Post.new(post_params) }

  before_action :verify_recaptcha!, only: :create

  def create
    respond_to do |format|
      format.json do
        entry.posts.push(post)
        if entry.save
          unless user_signed_in? || admin_signed_in?
            user = User.create
            user.remember_me!
            sign_in user
            render json: {app: {notice: {text: [t('msg.saved')]}, reload: true}}
          else
            render json: {app: {notice: {text: [t('msg.saved')]}}}
          end
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
