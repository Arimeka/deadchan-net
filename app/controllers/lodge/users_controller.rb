class Lodge::UsersController < Lodge::LodgeController
  expose(:users)  { User.desc(:last_sign_in_at).paginate(page: params[:page], per_page: 30) }
  expose(:user)   { User.find(params[:id]) }

  def destroy
    user.destroy
    respond_to do |format|
      flash[:notice] = t("msg.deleted")
      format.html {redirect_to lodge_users_url}
    end
  end

end
