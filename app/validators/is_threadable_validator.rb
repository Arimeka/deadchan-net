class IsThreadableValidator < ActiveModel::Validator
  def validate(record)
    begin
      if record.new_record? && !record.board.is_threadable?
        record.errors.add(:base, I18n.t('mongoid.models.errors.board.unthreadable'))
      end
    rescue StandardError
      record.errors.add(:base, I18n.t('mongoid.models.errors.unsaved'))
    end
  end
end
