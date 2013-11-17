class Tread
  include Mongoid::Document
  field :uid, type: Integer
  field :title, type: String
  field :is_published,  type: Mongoid::Boolean, default: true
  field :pin,  type: Mongoid::Boolean, default: false 


  # Validations
  # ======================================================
  validates :title, presence: true, length: { in: 2..30 }
  validates :uid, presence: true, uniqueness: true
  validates :pin, :is_published, inclusion: { in: [true, false] }

  # Scopes
  # ======================================================
  scope :published, where(is_published: true)

  # Relations
  # ======================================================
  belongs_to :board
  embeds_many :posts, dependent: :destroy
end