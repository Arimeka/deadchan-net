class UntilTimeValidator < ActiveModel::Validator
  def validate(record)
    begin
      if record.until.present? && record.until < Time.zone.now
        record.errors.add(:base, I18n.t('mongoid.models.errors.ban.wrong_until'))
      end
    rescue StandardError
      record.errors.add(:base, I18n.t('mongoid.models.errors.unsaved'))
    end
  end
end
