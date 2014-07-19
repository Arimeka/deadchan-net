class Lodge::PostsController < Lodge::LodgeController
  expose(:tread)  { Tread.find(params[:tread_id]) }
  expose(:post)  { tread.posts.find(params[:id]) }

  def destroy
    if post.delete
      respond_to do |format|
        flash[:notice] = t("msg.deleted")
        format.html {redirect_to lodge_tread_url(tread)}
      end
    else
      respond_to do |format|
        @errors = post.errors.full_messages
        flash[:error] = @errors
        format.html {redirect_to lodge_tread_url(tread)}
      end
    end
  end
end