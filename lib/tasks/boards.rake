namespace :boards do
  desc 'Тестовые данные для статистики'
  task test_statistic: :environment do
    Board.each do |board|
      # Постинг
      12.times do |cnt|
        time = Time.now - cnt.hours
        $redis.incrby("board:posts_count:#{board.id}:#{time.strftime('%Y-%m-%d-%H')}", rand(200))
        $redis.expire("board:posts_count:#{board.id}:#{time.strftime('%Y-%m-%d-%H')}", 24.hours)
      end
      # Посетители
      7.times do |cnt|
        time = Time.now - cnt.days
        $redis.incrby("board:views:#{board.id}:#{time.strftime('%Y-%m-%d')}", rand(2000))
        $redis.expire("board:views:#{board.id}:#{time.strftime('%Y-%m-%d')}", 7.days)
        500.times do
          $redis.pfadd("board:uniq_views:#{board.id}:#{time.strftime('%Y-%m-%d')}", rand(1000))
        end
        $redis.expire("board:uniq_views:#{board.id}:#{time.strftime('%Y-%m-%d')}", 7.days)
      end
    end
  end
end
