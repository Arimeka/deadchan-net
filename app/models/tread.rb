class Tread
  include Mongoid::Document

  field :board_id, type: String
  field :title, type: String
  field :content, type: String
  field :is_published,  type: Mongoid::Boolean, default: true
  field :published_at, type: Time
  field :updated_at, type: Time
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
  validates :posts_number,
            numericality: { only_integer: true }
  validates :board_id, presence: true
  validates :is_pinned, :is_published, :is_commentable,
            :is_full, inclusion: { in: [true, false] }

  # Scopes
  # ======================================================
  scope :published, -> { where(is_published: true, :published_at.lt => Time.now).desc(:updated_at) }

  # Relations
  # ======================================================
  belongs_to :board
  
  embeds_many :posts

  # Callbacks
  # ======================================================
  before_save :set_published_at, :check_is_full
  before_create :first_set_timestamps

  private
    def first_set_timestamps
      if is_published
        self.published_at = Time.now
        self.updated_at = Time.now
      end
    end

    def set_published_at
      if is_published && is_published_changed? && !published_at
        self.published_at = Time.now
      end
    end

    def check_is_full
      if self.posts.size > posts_number
        self.is_full = true
      else 
        self.is_full = false
        self.updated_at = Time.now
      end
      true
    end
end