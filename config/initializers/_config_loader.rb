SESSION_STORE   = YAML.load_file(Rails.root.join('config','session_store.yml'))[Rails.env]
REDIS_CONFIG    = YAML.load_file(Rails.root.join('config','redis.yml'))[Rails.env].symbolize_keys!
CACHE_PREFIX =  case Rails.env
                when 'development'
                  'localhost'
                when 'production'
                  'deadchan.net'
                when 'test'
                  'test.host'
                end