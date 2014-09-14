class IsCommentableValidator < ActiveModel::Validator
  def validate(record)
    begin
      unless record.tread.is_commentable?
        record.errors.add(:base, I18n.t('mongoid.models.errors.tread.uncommentable'))
      end
    rescue StandardError
      record.errors.add(:base, I18n.t('mongoid.models.errors.unsaved'))
    end
  end
end
