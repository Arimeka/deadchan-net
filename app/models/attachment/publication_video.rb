class Attachment::PublicationVideo < Attachment
  DEFAULT_PREVIEW_TIMESTAMP = 2

  has_mongoid_attached_file :file,
                            storage:        :s3,
                            s3_credentials: {bucket: S3_CONFIG['bucket'], access_key_id: S3_CONFIG['access_key_id'], secret_access_key: S3_CONFIG['secret_access_key']},
                            styles:         {preview: { geometry: '260x260^', format: 'png', time: DEFAULT_PREVIEW_TIMESTAMP }},
                            processors:     [:ffmpeg],
                            default_url:    File.join('missing', 'publication_video_:style.jpg'),
                            default_style:  :original,
                            path:           ':attachment/videos/:id/:style.:extension',
                            url:            ':s3_alias_url',
                            s3_host_alias:  'static-staging.deadchan.net',
                            s3_protocol:    'https',
                            use_timestamp:  false

  validates_attachment :file, presence: true
  validates_attachment :file, size: { in: 0..10.megabytes }
  validates_attachment :file, content_type: { content_type: %w[video/webm] }

  before_post_process :randomize_file_name

  embedded_in :videonable

  private

  def randomize_file_name
    return if file_file_name.nil?
    if file_file_name_changed?
      extension = File.extname(file_file_name).downcase
      self.file.instance_write(:file_name, "#{SecureRandom.hex}#{extension}")
    end
  end
end
