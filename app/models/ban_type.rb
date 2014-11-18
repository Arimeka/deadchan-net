class BanType
  include Mongoid::Document
  field :type, type: String

  # Relations
  # ======================================================
  has_many :bans, dependent: :destroy
end
