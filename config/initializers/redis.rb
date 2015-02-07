require 'redis'
Redis.current = Redis.new(REDIS_CONFIG)
$redis = Redis.current
