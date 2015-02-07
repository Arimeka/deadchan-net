class ClearUsersWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  sidekiq_options queue: 'scheduled', retry: 2

  recurrence { daily.hour_of_day(3) }

  def perform
    Timeout.timeout(200) do
      User.olds.destroy_all
    end
  rescue => e
    Sidekiq.logger.error "[ClearUsersWorker] #{Time.now.strftime("%Y.%m.%d %H:%M:%S")} ERROR: #{e.message}"
  end
end
