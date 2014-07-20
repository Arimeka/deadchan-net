class BoardsController < ApplicationController
  expose(:entry)  { Board.published.find_by(abbr: params[:abbr]) }
  expose(:treads) { entry.treads.includes(:board).published.paginate(page: params[:page], per_page: 10) }
  expose(:tread)  { entry.treads.build(tread_params) }

  private
    def tread_params
      params.fetch(:tread, {}).permit(:title, :content)
    end
end
