class BoardsController < ApplicationController
  include CheckPostingConcern

  expose(:entry)  { Board.published.find_by(abbr: params[:abbr]) }
  expose(:treads) { entry.treads.includes(:board).published.paginate(page: params[:page], per_page: 10) }
  expose(:tread)  { entry.treads.build(tread_params) }

  before_action :check_ban, :verify_recaptcha!, :check_last_posting,  only: :create

  def show
    redirect_to_good_slug and return if bad_slug?
  end

  def create
    respond_to do |format|
      format.html do
        unless user_signed_in? || admin_signed_in?
          user = User.create
          user.remember_me!
          sign_in user
        end
        tread.request_ip = IPAddr.new(request.ip).hton.force_encoding('UTF-8')
        if tread.save
          render json: {app: {notice: {text: [t('msg.saved')]}, redirect: tread_url(entry.abbr, tread.id)}}
          tread.set_counts(current_user)
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
        self.tread.build_image unless self.tread.image
        render partial: 'form'
      end
    end
  end

  private
    def tread_params
      params[:tread] = set_file(params[:tread], params[:file]) if params[:tread] && params[:file]
      params.fetch(:tread, {}).permit(:title, :content, image_attributes: [:id, :file], video_attributes: [:id, :file])
    end

    def verify_recaptcha!
      unless user_signed_in? || admin_signed_in?
        unless verify_recaptcha(model: tread)
          errors = tread.errors.full_messages
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
