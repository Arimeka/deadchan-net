class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include ContentSupport
  include ImageConcern

  field :content,       type: String
  field :replies,       type: Array                           # [{board_abbr, tread_id, post_id}, ...]
  field :is_published,  type: Mongoid::Boolean, default: true
  field :is_checked,    type: Mongoid::Boolean, default: false
  field :request_ip,    type: BSON::Binary

  attr_accessor :lodge

  # Validations
  # ======================================================
  validates :content, presence: true, length: { in: 1..2500 }, unless: 'self.image || self.video'
  validates :content, length: { maximum: 2500 }
  validates :is_published, inclusion: { in: [true, false] }

  validates_with IsCommentableValidator, on: :create, unless: 'lodge'

  # Scopes
  # ======================================================
  scope :published, -> { where(is_published: true).asc(:created_at) }
  scope :unchecked, -> { where(is_checked: false) }

  # Relations
  # ======================================================
  embedded_in :tread
  has_image :image, Attachment::PublicationImage
  has_file  :video, Attachment::PublicationVideo
end
