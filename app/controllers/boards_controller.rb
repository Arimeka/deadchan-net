class BoardsController < ApplicationController
  expose(:board)  { Board.published.find_by(abbr: params[:abbr]) }
  expose(:treads) { board.treads.published.paginate(page: params[:page], per_page: 10) }
  expose(:tread)  { board.treads.build(tread_params) }

  def create
    respond_to do |format|
      format.json do
        tread.content = markdown(tread.content)
        if tread.save
          render json: {app: {notice: {text: t('msg.saved')}, redirect: tread_url(board.abbr, tread.id)}}
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
