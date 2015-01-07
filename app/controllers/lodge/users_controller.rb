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

  def unpablish_posts
    ip = IPAddr.new(params[:request_ip]).hton
    Tread.where(request_ip: ip).update_all(is_published: false)
    Tread.where("posts.request_ip" => ip).each do |tread|
      tread.posts.where(request_ip: ip).update_all(is_published: false)
    end
    respond_to do |format|
      flash[:notice] = t("msg.unpublish")
      format.html {redirect_to lodge_users_url}
    end
  end

  def destroy_posts
    ip = IPAddr.new(params[:request_ip]).hton
    Tread.where(request_ip: ip).destroy_all
    Tread.where("posts.request_ip" => ip).each do |tread|
      tread.posts.where(request_ip: ip).destroy_all
    end
    respond_to do |format|
      flash[:notice] = t("msg.deleted")
      format.html {redirect_to lodge_users_url}
    end
  end
end
