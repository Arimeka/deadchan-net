class Board
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  field :abbr, type: String
  field :placement_index, type: Integer, default: 0
  field :threads_number, type: Integer, default: 200
  field :is_threadable, type: Mongoid::Boolean, default: true
  field :is_published,  type: Mongoid::Boolean, default: true


  # Validations
  # ======================================================
  validates :title, presence: true, length: { in: 2..30 }
  validates :abbr, presence: true, uniqueness: true, length: { in: 1..4 }
  validates :placement_index, :threads_number, numericality: { only_integer: true }
  validates :is_threadable, :is_published, inclusion: { in: [true, false] }

  # Scopes
  # ======================================================
  scope :published, -> { where(is_published: true) }

  # Relations
  # ======================================================
  has_many :treads, dependent: :destroy

  # Callbacks
  # ======================================================
  after_save :unpublish_olds

  def is_threadable
    if Settings.readonly
      false
    else
      super
    end
  end

  def is_threadable?
    if Settings.readonly
      false
    else
      super
    end
  end

  private

    def unpublish_olds
      if threads_number < self.treads.published.count
        self.treads.published.skip(threads_number).each do |t|
          t.set(is_published: false)
        end
      end
      true
    end
end
