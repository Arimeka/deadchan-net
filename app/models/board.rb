class Board
  include Mongoid::Document
  field :title, type: String
  field :abbr, type: String
  field :placement_index, type: Integer, default: 0
  field :threads_number, type: Integer, default: 200
  field :is_threadable, type: Mongoid::Boolean, default: true
  field :is_published,  type: Mongoid::Boolean, default: true
  field :sequence, type: Integer, default: 0


  # Validations
  # ======================================================
  validates :title, presence: true, length: { in: 2..30 }
  validates :abbr, presence: true, uniqueness: true, length: { in: 1..4 }
  validates :placement_index, :threads_number, :sequence, numericality: { only_integer: true }
  validates :is_threadable, :is_published, inclusion: { in: [true, false] }

  # Scopes
  # ======================================================
  scope :published, where(is_published: true)

  # Relations
  # ======================================================
  has_many :treads, dependent: :destroy
end
