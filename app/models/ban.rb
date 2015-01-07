class Ban
  include Mongoid::Document
  include Mongoid::Timestamps

  field :ban_type_id, type: String
  field :reason,      type: String
  field :until,       type: Time
  field :request_ip,  type: BSON::Binary

  # Relations
  # ======================================================
  belongs_to :ban_type

  # Callbacks
  # ======================================================
  after_save      :save_to_redis
  before_destroy  :delete_in_redis

  # Validations
  # ======================================================
  validates_with UntilTimeValidator

  private

  def save_to_redis
    if self.until.present? && self.until > Time.zone.now
      time = (self.until - Time.zone.now).to_i
    end
    $redis.del("bans:#{BanType.find(ban_type_id_was).type}:#{request_ip_was}") if ban_type_id_was
    $redis.set("bans:#{self.ban_type.type}:#{request_ip}", reason, ex: time)
  end

  def delete_in_redis
    $redis.del("bans:#{self.ban_type.type}:#{request_ip}")
  end
end
