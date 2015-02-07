class Lodge::PostsController < Lodge::LodgeController
  expose(:tread)  { Tread.find(params[:tread_id]) }
  expose(:post)   { params[:id] ? tread.posts.find(params[:id]) : Post.new(post_params.merge(lodge: true)) }

  def new
    self.post.build_image unless self.post.image
  end

  def edit
    self.post.build_image unless self.post.image
  end

  def create
    tread.posts.push(post)
    if tread.save
      flash[:notice] = t('msg.saved')
      if params[:commit] == t('form.save_and_exit')
        redirect_to lodge_tread_url(tread)
      else
        redirect_to edit_lodge_tread_post_url(tread,post)
      end
    else
      @errors = post.errors.full_messages
      flash.now[:error] = t("msg.save_error")
      render :new
    end
  end

  def update
    if request.xhr?
      post.update_attributes(post_params.merge(lodge: true))
      render nothing: true
    else
      if post.update_attributes(post_params.merge(lodge: true))
        flash[:notice] = t('msg.saved')
        if params[:commit] == t('form.save_and_exit')
          redirect_to lodge_tread_url(tread)
        else
          redirect_to edit_lodge_tread_post_url(tread,post)
        end
      else
        @errors = post.errors.full_messages
        flash.now[:error] = t("msg.save_error")
        render :edit
      end
    end
  end

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

  private

    def post_params
      params.fetch(:post, {}).permit(:content, :is_published, :is_checked,
                                      image_attributes: [:id, :file, :_destroy])
    end
end
