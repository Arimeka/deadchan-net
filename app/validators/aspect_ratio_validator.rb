class AspectRatioValidator < ActiveModel::Validator
  def validate(record)
    begin
      if record.file.staged?
        path = record.file.queued_for_write[:original].path
        aspect_ratio = Paperclip.run("identify -format '%[fx:w/h]' #{path}")
        if aspect_ratio.to_f < 0.01 || aspect_ratio.to_f > 100
          record.errors.add(:file, I18n.t('mongoid.models.errors.attachment.bad_aspect_ratio'))
        end
      end
    rescue StandardError
      record.errors.add(:file, I18n.t('mongoid.models.errors.unsaved'))
    end
  end
end
