json.cache! "tread/posts/#{tread.id}/#{posts.last.id}/#{posts.last.updated_at.to_i}" do
  json.array!(posts) do |post|
    json.partial! post
  end
end
