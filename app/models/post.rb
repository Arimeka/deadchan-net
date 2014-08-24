class Post
  include Mongoid::Document
  include Mongoid::Timestamps
  include ContentSupport

  field :content,       type: String
  field :replies,       type: Array                           # [{board_abbr, tread_id, post_id}, ...]
  field :is_published,  type: Mongoid::Boolean, default: true

  attr_accessor :lodge

  # Validations
  # ======================================================
  validates :content, presence: true, length: { in: 1..2500 }
  validates :is_published, inclusion: { in: [true, false] }

  # Scopes
  # ======================================================
  scope :published, -> { where(is_published: true).asc(:created_at) }

  # Relations
  # ======================================================
  embedded_in :tread
end
