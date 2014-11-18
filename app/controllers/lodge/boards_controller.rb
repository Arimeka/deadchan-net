class Lodge::BoardsController < Lodge::LodgeController
  expose(:boards) { Board.asc(:placement_index).paginate(page: params[:page]) }
  expose(:board)  { params[:id] ? Board.find(params[:id]) : Board.new(board_params) }
  expose(:treads) { board.treads.includes(:board).desc(:is_pinned).desc(:updated_at).paginate(page: params[:page], per_page: 30) }

  def create
    if board.save
      flash[:notice] = t('msg.saved')
      if params[:commit] == t('form.save_and_exit')
        redirect_to lodge_board_url board
      else
        redirect_to edit_lodge_board_url board
      end
    else
      @errors = board.errors.full_messages
      flash.now[:error] = t("msg.save_error")
      render :new
    end
  end

  def update
    if board.update_attributes(board_params)
      flash[:notice] = t('msg.saved')
      if params[:commit] == t('form.save_and_exit')
        redirect_to lodge_board_url board
      else
        redirect_to edit_lodge_board_url board
      end
    else
      @errors = board.errors.full_messages
      flash.now[:error] = t("msg.save_error")
      render :edit
    end
  end

  def destroy
    if board.destroy
      respond_to do |format|
        flash[:notice] = t("msg.deleted")
        format.html {redirect_to lodge_boards_url}
      end
    else
      respond_to do |format|
        @errors = board.errors.full_messages
        flash[:error] = @errors
        format.html {redirect_to edit_lodge_board_url(board)}
      end
    end
  end

  private
    def board_params
      params.fetch(:board, {}).permit(:title, :abbr, :placement_index,
                                :threads_number, :is_threadable, :is_published)
    end
end
