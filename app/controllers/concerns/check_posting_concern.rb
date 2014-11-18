module CheckPostingConcern
  extend ActiveSupport::Concern

  included do
    before_action :check_ban, :verify_recaptcha!, :check_last_posting, only: :create
  end

  def check_ban
    unless admin_signed_in?
      if $redis.exists("bans:readonly:#{request.ip}") || $redis.exists("bans:full:#{request.ip}")
        errors = [t('mongoid.models.errors.user.banned')]
        text = $redis.get("bans:readonly:#{request.ip}") || $redis.get("bans:full:#{request.ip}")
        errors << "Причина бана: #{text}" if text.present?
        render json: {app: {error: {text: errors}}}
      end
    end
  end

  def check_last_posting
    unless admin_signed_in?
      if user_signed_in?
        if $redis.get("last_posting:#{current_user.id}")
          session.keys.each { |key| session.delete key }
        end
      end
    end
  end
end
