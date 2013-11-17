class Tread
  include Mongoid::Document
  field :nuid, type: Integer
  field :posts_count, type: Integer, default: 0
  field :title, type: String
  field :is_published,  type: Mongoid::Boolean, default: true
  field :is_commentable,  type: Mongoid::Boolean, default: true
  field :is_pinned,  type: Mongoid::Boolean, default: false 
  field :posts_number, type: Integer, default: 500
  field :is_full,  type: Mongoid::Boolean, default: false


  # Validations
  # ======================================================
  validates :title, presence: true, length: { in: 2..30 }
  validates :posts_count, :posts_number, 
            numericality: { only_integer: true }
  validates :nuid, presence: true
  validates :is_pinned, :is_published, :is_commentable,
            :is_full, inclusion: { in: [true, false] }

  # Scopes
  # ======================================================
  scope :published, where(is_published: true)

  # Relations
  # ======================================================
  belongs_to :board
  
  embeds_many :posts
  accepts_nested_attributes_for :posts
end