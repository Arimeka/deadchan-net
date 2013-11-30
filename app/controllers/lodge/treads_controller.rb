class Lodge::TreadsController < Lodge::LodgeController
  expose(:boards) { Board.published }
  expose(:treads) { Tread.paginate(page: params[:page]) }
  expose(:tread) { params[:id] ? Tread.find(params[:id]) : Tread.new(tread_params) }

  def index
  end

  def show
  end

  def new
  end

  def create
    if tread.save
      flash[:notice] = t('msg.saved')
      if params[:commit] == t('form.save_and_exit')
        redirect_to lodge_tread_url tread
      else
        redirect_to edit_lodge_tread_url tread
      end
    else
      @errors = tread.errors.full_messages
      flash[:error] = t("msg.save_error")
      render :new
    end
  end

  def edit
  end

  def update
    if tread.update_attributes(tread_params)
      flash[:notice] = t('msg.saved')
      if params[:commit] == t('form.save_and_exit')
        redirect_to lodge_tread_url tread
      else
        redirect_to edit_lodge_tread_url tread
      end
    else
      @errors = tread.errors.full_messages
      flash[:error] = t("msg.save_error")
      render :edit
    end
  end

  def destroy
    if tread.delete
      respond_to do |format|
        flash[:notice] = t("msg.deleted")
        format.html {redirect_to lodge_treads_url}
      end
    else
      respond_to do |format|
          @errors = tread.errors.full_messages
          flash[:error] = @errors 
          format.html {redirect_to edit_lodge_tread_url(tread)}
        end
    end
  end

  private
    def tread_params
      params.fetch(:tread, {}).permit(:title, :content,
                                        :is_published, :pin, 
                                        :is_commentable, :posts_number,
                                        :board_id, :is_admin, :show_name)      
    end
end