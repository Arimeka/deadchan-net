json.cache! entry do
  json.(entry, :_id, :title, :content, :published_at, :replies, :is_commentable, :is_pinned)
  json.image (entry.image && entry.image.file?) ? entry.image.url(:original) : nil
  json.image_thumb (entry.image && entry.image.file?) ? entry.image.url : nil
  json.video (entry.video && entry.video.file?) ? entry.video.url : nil
  json.video_preview (entry.video && entry.video.file?) ? entry.video.url(:preview) : nil
end
