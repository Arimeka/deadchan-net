class Post
  include Mongoid::Document
  field :nuid, type: Integer
  field :is_published,  type: Mongoid::Boolean, default: true
  field :content,  type: String


  # Validations
  # ======================================================
  validates :content, presence: true, length: { in: 1..2500 }
  validates :nuid, presence: true
  validates :is_published, inclusion: { in: [true, false] }

  # Scopes
  # ======================================================
  scope :published, where(is_published: true)

  # Relations
  # ======================================================
  belongs_to :tread
end