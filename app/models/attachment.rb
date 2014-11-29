class Attachment
  include Mongoid::Document
  include Mongoid::Paperclip

  delegate :url, to: :file
end
