class BoardsController < ApplicationController
  expose(:board) { Board.published.find_by(abbr: params[:abbr]) }

  def show
  end
end
