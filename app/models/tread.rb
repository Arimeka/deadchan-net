class Tread
  include Mongoid::Document
  include ContentSupport
  include ImageConcern

  field :board_id,        type: String
  field :user_id,         type: String
  field :title,           type: String
  field :content,         type: String
  field :published_at,    type: Time
  field :updated_at,      type: Time
  field :replies,         type: Array                             # [{board_abbr, tread_id, post_id}, ...]
  field :is_commentable,  type: Mongoid::Boolean, default: true
  field :is_published,    type: Mongoid::Boolean, default: true
  field :is_pinned,       type: Mongoid::Boolean, default: false
  field :is_full,         type: Mongoid::Boolean, default: false
  field :is_admin,        type: Mongoid::Boolean, default: false
  field :posts_number,    type: Integer,          default: 500
  field :request_ip,      type: BSON::Binary

  attr_accessor :lodge

  # Validations
  # ======================================================
  validates :title, presence: true, length: { in: 2..30 }
  validates :content, presence: true, length: { in: 1..2500 }, unless: 'self.image || self.video'
  validates :content, length: { maximum: 2500 }
  validates :posts_number,
            numericality: { only_integer: true }
  validates :board_id, presence: true
  validates :is_pinned, :is_published, :is_commentable,
            :is_full, inclusion: { in: [true, false] }

  validates_with IsThreadableValidator, on: :create, unless: 'lodge'

  # Scopes
  # ======================================================
  scope :published, -> { where(is_published: true, :published_at.lt => Time.zone.now).desc(:is_pinned).desc(:updated_at) }

  # Relations
  # ======================================================
  belongs_to :board
  belongs_to :user

  embeds_many :posts, cascade_callbacks: true

  has_image :image, Attachment::PublicationImage
  has_file  :video, Attachment::PublicationVideo

  # Callbacks
  # ======================================================
  before_save :set_published_at, :check_is_full
  before_create :first_set_timestamps
  after_create :unpublish_old


  def is_commentable
    if Settings.readonly
      false
    else
      super
    end
  end

  def is_commentable?
    if Settings.readonly
      false
    else
      super
    end
  end

  private

    def first_set_timestamps
      if is_published?
        self.published_at = Time.zone.now unless published_at
        self.updated_at = Time.zone.now unless updated_at
      end
    end

    def set_published_at
      if is_published && is_published_changed? && !published_at
        self.published_at = Time.zone.now
      end
    end

    def check_is_full
      if self.posts.size > posts_number
        self.is_full = true
      else
        self.is_full = false
        self.updated_at = Time.zone.now
      end
      true
    end

    def unpublish_old
      if self.board.threads_number < self.board.treads.published.count
        self.board.treads.published.last.set(is_published: false)
      end
      true
    end
end
