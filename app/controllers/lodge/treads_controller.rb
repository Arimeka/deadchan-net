class Lodge::TreadsController < Lodge::LodgeController
  expose(:treads) { Tread.desc(:is_pinned).desc(:updated_at).includes(:board).paginate(page: params[:page], per_page: 30) }
  expose(:tread)  { params[:id] ? Tread.find(params[:id]) : Tread.new(tread_params.merge(lodge: true)) }
  expose(:posts)  { tread.posts.paginate(page: params[:page], per_page: 30) }

  def new
    self.tread.build_image unless self.tread.image
  end

  def edit
    self.tread.build_image unless self.tread.image
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
      flash.now[:error] = t("msg.save_error")
      self.tread.build_image unless self.tread.image
      render :new
    end
  end

  def update
    if tread.update_attributes(tread_params.merge(lodge: true))
      flash[:notice] = t('msg.saved')
      if params[:commit] == t('form.save_and_exit')
        redirect_to lodge_tread_url tread
      else
        redirect_to edit_lodge_tread_url tread
      end
    else
      @errors = tread.errors.full_messages
      flash.now[:error] = t("msg.save_error")
      self.tread.build_image unless self.tread.image
      render :edit
    end
  end

  def destroy
    if tread.destroy
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
                                        :is_published, :is_pinned,
                                        :is_commentable, :posts_number,
                                        :board_id, :is_admin, :show_name,
                                        :lodge,
                                        image_attributes: [:id, :file, :_destroy])
    end
end
