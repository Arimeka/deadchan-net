# enable logging only in development/test environments
if Rails.env.production?
  MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017)
else
  mongo_logger = Logger.new('log/mongo_mapper.log')
  MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017, logger: mongo_logger)
end