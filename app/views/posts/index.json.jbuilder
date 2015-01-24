json.cache! "tread/posts/#{tread.id}/#{posts.last.id}/#{posts.last.updated_at.to_i}" do
  json.array!(posts) do |post|
    json.(post, :_id, :content, :created_at, :replies)
    json.image (post.image && post.image.file?) ? post.image.url(:original) : nil
    json.image_thumb (post.image && post.image.file?) ? post.image.url : nil
    json.video (post.video && post.video.file?) ? post.video.url : nil
    json.video_preview (post.video && post.video.file?) ? post.video.url(:preview) : nil
    json.tread_id post.tread.id.to_s
  end
end
