class BoardsController < ApplicationController
  expose(:board) { Board.published.find_by(abbr: params[:abbr]) }
  expose(:treads) { board.treads.published.paginate(page: params[:page]) }

  def show
  end
end
