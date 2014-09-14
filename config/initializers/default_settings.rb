DeadchanNet::Application.application_config.try(:[], 'settings').tap do |default_settings|
  Settings.defaults.merge!(default_settings) if default_settings.present?
end
