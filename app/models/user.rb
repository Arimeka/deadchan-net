class User
  include Mongoid::Document
  devise :rememberable, :trackable

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Lockable
  field :locked_at,       :type => Time

  # Relations
  # ======================================================
  has_many :treads

  # Scopes
  # ======================================================
  scope :olds, -> { where(:current_sign_in_at.lt => Time.zone.now - 1.day)}
end
