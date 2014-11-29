class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include ContentSupport
  include ImageConcern

  field :user_id,       type: String
  field :content,       type: String
  field :replies,       type: Array                           # [{board_abbr, tread_id, post_id}, ...]
  field :is_published,  type: Mongoid::Boolean, default: true
  field :request_ip,    type: BSON::Binary

  attr_accessor :lodge

  # Validations
  # ======================================================
  validates :content, presence: true, length: { in: 1..2500 }
  validates :is_published, inclusion: { in: [true, false] }

  validates_with IsCommentableValidator, on: :create, unless: 'lodge'

  # Scopes
  # ======================================================
  scope :published, -> { where(is_published: true).asc(:created_at) }

  # Relations
  # ======================================================
  embedded_in :tread
  has_image :image, Attachment::PublicationImage
end
