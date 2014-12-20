class Attachment::PublicationImage < Attachment
  has_mongoid_attached_file :file,
                            storage:        :s3,
                            s3_credentials: {bucket: S3_CONFIG['bucket'], access_key_id: S3_CONFIG['access_key_id'], secret_access_key: S3_CONFIG['secret_access_key']},
                            styles:         { s260x260: {geometry: '260x260#'} },
                            processors:     [:thumbnail],
                            default_url:    File.join('missing', 'publication_image_:style.jpg'),
                            default_style:  :s260x260,
                            path:           ':attachment/images/:id/:style.:extension',
                            url:            ':s3_domain_url'

  validates_attachment :file, presence: true
  validates_attachment :file, size: { in: 0..10.megabytes }
  validates_attachment :file, content_type: { content_type: %w[image/jpg image/gif image/png image/jpeg] }

  before_post_process :randomize_file_name

  embedded_in :imaginable

  private

  def randomize_file_name
    return if file_file_name.nil?
    if file_file_name_changed?
      extension = File.extname(file_file_name).downcase
      self.file.instance_write(:file_name, "#{SecureRandom.hex}#{extension}")
    end
  end
end
