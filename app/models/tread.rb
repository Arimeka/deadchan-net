class Tread
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nuid, type: Integer
  field :board_id, type: String
  field :posts_count, type: Integer, default: 0
  field :title, type: String
  field :content, type: String
  field :is_published,  type: Mongoid::Boolean, default: true
  field :is_commentable,  type: Mongoid::Boolean, default: true
  field :is_pinned,  type: Mongoid::Boolean, default: false 
  field :posts_number, type: Integer, default: 500
  field :is_full,  type: Mongoid::Boolean, default: false
  field :is_admin, type: Mongoid::Boolean, default: false
  field :show_name, type: Mongoid::Boolean, default: false

  # Validations
  # ======================================================
  validates :title, presence: true, length: { in: 2..30 }
  validates :posts_count, :posts_number, 
            numericality: { only_integer: true }
  validates :board_id, presence: true
  validates :is_pinned, :is_published, :is_commentable,
            :is_full, inclusion: { in: [true, false] }

  # Scopes
  # ======================================================
  scope :published, where(is_published: true)

  # Relations
  # ======================================================
  belongs_to :board
  
  embeds_many :posts

  # Callbacks
  # ======================================================
  before_save :set_nuid


  private
    def set_nuid
      unless nuid
        board = Board.find(board_id)
        self.nuid = board.sequence
        board.inc(sequence: 1)
      end
    end
end