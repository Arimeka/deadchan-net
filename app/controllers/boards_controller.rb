class BoardsController < ApplicationController
  include CheckPostingConcern

  expose(:entry)  { Board.published.find_by(abbr: params[:abbr]) }
  expose(:treads) { entry.treads.includes(:board).published.paginate(page: params[:page], per_page: 10) }
  expose(:tread)  { entry.treads.build(tread_params) }

  before_action :check_ban, :verify_recaptcha!, :check_last_posting,  only: :create

  def create
    respond_to do |format|
      format.html do
        unless user_signed_in? || admin_signed_in?
          user = User.create
          user.remember_me!
          sign_in user
        end
        tread.user_id = current_user.id if current_user
        tread.request_ip = IPAddr.new(request.ip).hton
        if tread.save
          render json: {app: {notice: {text: [t('msg.saved')]}, redirect: tread_url(entry.abbr, tread.id)}}
          $redis.set("last_posting:#{current_user.id}", 1, ex: 10)
        else
          errors = tread.errors.full_messages
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
    def tread_params
      params.fetch(:tread, {}).permit(:title, :content)
    end

    def verify_recaptcha!
      unless user_signed_in? || admin_signed_in?
        unless verify_recaptcha(model: tread)
          errors = tread.errors.full_messages
          render json: {app: {error: {text: errors}}}
        end
      end
    end
end
