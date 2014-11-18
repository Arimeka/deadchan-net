class Lodge::BansController < Lodge::LodgeController
  expose(:ban_types)  { BanType.all }
  expose(:bans)       { Ban.desc(:updated_at).includes(:ban_type).paginate(page: params[:page], per_page: 30) }
  expose(:ban)        { params[:id] ? Ban.find(params[:id]) : Ban.new(ban_params) }

  def create
    if ban.save
      flash[:notice] = t('msg.saved')
      if params[:commit] == t('form.save_and_exit')
        redirect_to lodge_bans_url
      else
        redirect_to edit_lodge_ban_url(ban)
      end
    else
      @errors = ban.errors.full_messages
      flash.now[:error] = t("msg.save_error")
      render :new
    end
  end

  def update
    if ban.update_attributes(ban_params)
      flash[:notice] = t('msg.saved')
      if params[:commit] == t('form.save_and_exit')
        redirect_to lodge_bans_url
      else
        redirect_to edit_lodge_ban_url(ban)
      end
    else
      @errors = ban.errors.full_messages
      flash.now[:error] = t("msg.save_error")
      render :edit
    end
  end

  def destroy
    respond_to do |format|
      format.html do
        if ban.destroy
          flash[:notice] = t("msg.deleted")
          redirect_to lodge_bans_url
        else
          @errors = ban.errors.full_messages
          flash[:error] = @errors
          redirect_to lodge_bans_url
        end
      end
    end
  end

  private

    def ban_params
      params.fetch(:ban, {}).permit(:user_id, :ban_type_id, :reason, :until, :request_ip)
    end
end
