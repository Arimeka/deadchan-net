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

  def self.get_posting_statistic(board_id, count = 12)
    result = []
    count.to_i.times do |cnt|
      time_key = (Time.now - cnt.hours).strftime('%Y-%m-%d-%H')
      time = (Time.now - cnt.hours).strftime('%H:00')
      result << {time: time, count: $redis.get("board:posts_count:#{board_id}:#{time_key}").to_i}
    end
    result.reverse
  end

  def self.get_visits_statistic(board_id, count = 7)
    result = []
    count.to_i.times do |cnt|
      time_key = (Time.now - cnt.days).strftime('%Y-%m-%d')
      time = Russian::strftime((Time.now - cnt.days), '%A')
      result << {time: time, views: $redis.get("board:views:#{board_id}:#{time_key}").to_i, uniq: $redis.pfcount("board:uniq_views:#{board_id}:#{time_key}").to_i}
    end
    result.reverse
  end

  def self.get_posting_summary_statistic(count = 12)
    result = []
    count.to_i.times do |cnt|
      time_key = (Time.now - cnt.hours).strftime('%Y-%m-%d-%H')
      time = (Time.now - cnt.hours).strftime('%H:00')
      result << {time: time, count: $redis.get("summary:posts_count:#{time_key}").to_i}
    end
    result.reverse
  end

  def self.get_visits_summary_statistic(count = 7)
    result = []
    count.to_i.times do |cnt|
      time_key = (Time.now - cnt.days).strftime('%Y-%m-%d')
      time = Russian::strftime((Time.now - cnt.days), '%A')
      result << {time: time, views: $redis.get("summary:views:#{time_key}").to_i, uniq: $redis.pfcount("summary:uniq_views:#{time_key}").to_i}
    end
    result.reverse
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
