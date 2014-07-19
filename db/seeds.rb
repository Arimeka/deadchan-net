# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = Admin.new(email: 'foobar@foobar.com', password: 'foobar', password_confirmation: 'foobar')
admin.save!(validate: false)


boards = Board.create([ {title: 'graveyard', abbr: 'gr'},
                        {title: 'about', abbr: 'ab'},
                        {title: 'mackaking', abbr: 'mac'}
                      ])

boards.each do |board|
  40.times do
    tread = board.treads.create!(title: Faker::Lorem.words(2).join(' '), content: Faker::Lorem.paragraphs.join("<br><br>"))
    posts = []
    80.times do
      post = Post.new(content: Faker::Lorem.paragraphs.join("<br><br>"))
      tread.posts.push(post)
      tread.save!
    end
  end
end