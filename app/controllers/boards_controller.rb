class BoardsController < ApplicationController
  expose(:board)  { Board.published.find_by(abbr: params[:abbr]) }
  expose(:treads) { board.treads.published.paginate(page: params[:page]) }
  expose(:tread)  { board.treads.build(tread_params) }

  def show
  end

  def create
    respond_to do |format|
      format.json do
        tread.content = markdown(tread.content)
        if tread.save
          render json: {app: {notice: {text: t('msg.saved')}, redirect: tread_url(board.abbr, tread.nuid)}}
        else
          errors = tread.errors.full_messages
          render json: {app: {error: {text: errors}}}
        end
      end
    end
  end

  private
    def tread_params
      params.fetch(:tread, {}).permit(:title, :content)      
    end
end
