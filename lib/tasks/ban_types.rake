namespace :ban_types do
  desc 'Создание типов банов'
  task create: :environment do
    BanType.find_or_create_by(type: 'full')
    BanType.find_or_create_by(type: 'readonly')
  end
end
