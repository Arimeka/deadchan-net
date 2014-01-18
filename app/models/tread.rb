class Tread
  include Mongoid::Document
  include Mongoid::Timestamps

  field :nuid, type: Integer
  field :board_id, type: String
  field :posts_count, type: Integer, default: 0
  field :title, type: String
  field :content, type: String
  field :is_published,  type: Mongoid::Boolean, default: true
  field :published_at, type: Time
  field :is_commentable,  type: Mongoid::Boolean, default: true
  field :is_pinned,  type: Mongoid::Boolean, default: false 
  field :posts_number, type: Integer, default: 500
  field :is_full,  type: Mongoid::Boolean, default: false
  field :is_admin, type: Mongoid::Boolean, default: false
  field :show_name, type: Mongoid::Boolean, default: false
  field :sequence, type: Integer, default: 0

  # Validations
  # ======================================================
  validates :title, presence: true, length: { in: 2..30 }
  validates :content, presence: true, length: { in: 1..2500 }
  validates :posts_count, :posts_number, 
            numericality: { only_integer: true }
  validates :board_id, presence: true
  validates :is_pinned, :is_published, :is_commentable,
            :is_full, inclusion: { in: [true, false] }

  # Scopes
  # ======================================================
  scope :published, where(is_published: true).desc(:published_at)

  # Relations
  # ======================================================
  belongs_to :board
  
  embeds_many :posts

  # Callbacks
  # ======================================================
  before_save :set_nuid, :set_published_at
  before_create :first_set_published_at

  private
    def set_nuid
      unless nuid
        board = Board.find(board_id)
        self.nuid = board.sequence
        board.inc(sequence: 1)
      end
    end

    def first_set_published_at
      if is_published
        self.published_at = Time.now
      end
    end

    def set_published_at
      if is_published && is_published_changed? && !published_at
        self.published_at = Time.now
      end
    end
end