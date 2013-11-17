class Lodge::ThreadsController < Lodge::LodgeController
  expose(:threads) { Tread.paginate(page: params[:page]) }
  expose(:thread) { params[:id] ? Tread.find(params[:id]) : Tread.new(thread_params) }

  def index
  end

  def show
  end

  def new
  end

  def create
    if thread.save
      flash[:notice] = t('msg.saved')
      if params[:commit] == t('form.save_and_exit')
        redirect_to lodge_thread_url thread
      else
        redirect_to edit_lodge_thread_url thread
      end
    else
      @errors = thread.errors.full_messages
      flash[:error] = t("msg.save_error")
      render :new
    end
  end

  def edit
  end

  def update
    if thread.update_attributes(thread_params)
      flash[:notice] = t('msg.saved')
      if params[:commit] == t('form.save_and_exit')
        redirect_to lodge_thread_url thread
      else
        redirect_to edit_lodge_thread_url thread
      end
    else
      @errors = thread.errors.full_messages
      flash[:error] = t("msg.save_error")
      render :edit
    end
  end

  def destroy
    if thread.delete
      respond_to do |format|
        flash[:notice] = t("msg.deleted")
        format.html {redirect_to lodge_threads_url}
      end
    else
      respond_to do |format|
          @errors = thread.errors.full_messages
          flash[:error] = @errors 
          format.html {redirect_to edit_lodge_thread_url(thread)}
        end
    end
  end

  private
    def thread_params
      params.fetch(:thread, {}).permit(:content,:is_published,:pin)
    end
end