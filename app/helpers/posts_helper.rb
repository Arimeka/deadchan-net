module PostsHelper
  def post_status(post)
    if !post.is_published?
      'bg-danger'
    elsif !post.is_checked?
      'bg-warning'
    else
      'bg-success'
    end
  end
end
