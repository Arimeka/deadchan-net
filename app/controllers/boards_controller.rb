class BoardsController < ApplicationController
  expose(:entry)  { Board.published.find_by(abbr: params[:abbr]) }
  expose(:treads) { entry.treads.includes(:board).published.paginate(page: params[:page], per_page: 10) }
  expose(:tread)  { entry.treads.build(tread_params) }

  def create
    respond_to do |format|
      if (user_signed_in? || admin_signed_in?) && request.xhr?
        format.json do
          if tread.save
            render json: {app: {notice: {text: t('msg.saved')}, redirect: tread_url(entry.abbr, tread.id)}}
          else
            errors = tread.errors.full_messages
            render json: {app: {error: {text: errors}}}
          end
        end
      else
        format.html do
          if verify_recaptcha
            if tread.save
              user = User.create
              user.remember_me!
              sign_in user
              redirect_to tread_url(entry.abbr, tread.id), notice: t('msg.saved')
            else
              flash.now[:error] = tread.errors.full_messages
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
    def tread_params
      params.fetch(:tread, {}).permit(:title, :content)      
    end
end
