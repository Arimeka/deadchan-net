Recaptcha.configure do |config|
  config.public_key  = RECAPTCHA['public_key']
  config.private_key = RECAPTCHA['private_key']
  config.api_version = 'v2'
end
