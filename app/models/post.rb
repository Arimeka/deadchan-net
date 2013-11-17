class Post
  include Mongoid::Document
  field :uid, type: Integer
  field :is_published,  type: Mongoid::Boolean, default: true
  field :content,  type: Text


  # Validations
  # ======================================================
  validates :content, presence: true, length: { in: 1..2500 }
  validates :uid, presence: true, uniqueness: true
  validates :is_published, inclusion: { in: [true, false] }

  # Scopes
  # ======================================================
  scope :published, where(is_published: true)

  # Relations
  # ======================================================
  belongs_to :tread
end