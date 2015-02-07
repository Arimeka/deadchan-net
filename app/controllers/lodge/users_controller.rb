class Lodge::UsersController < Lodge::LodgeController
  def unpablish_posts
    ip = IPAddr.new(params[:request_ip]).hton.force_encoding('UTF-8')
    Tread.where(request_ip: ip).update_all(is_published: false)
    Tread.where("posts.request_ip" => ip).each do |tread|
      tread.posts.where(request_ip: ip).update_all(is_published: false)
    end
    respond_to do |format|
      flash[:notice] = t("msg.unpublish")
      format.html {redirect_to lodge_url}
    end
  end

  def destroy_posts
    ip = IPAddr.new(params[:request_ip]).hton.force_encoding('UTF-8')
    Tread.where(request_ip: ip).destroy_all
    Tread.where("posts.request_ip" => ip).each do |tread|
      tread.posts.where(request_ip: ip).destroy_all
    end
    respond_to do |format|
      flash[:notice] = t("msg.deleted")
      format.html {redirect_to lodge_url}
    end
  end
end
