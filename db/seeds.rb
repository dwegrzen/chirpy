# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

usednames = []
usedemail = []
users = 100.times.map do
  tempname = nil
  tempemail = nil
  while tempname.blank? || usednames.include?(tempname)
    tempname = Faker::Internet.user_name
  end
  usednames << tempname
  while tempemail.blank? || usedemail.include?(tempemail)
    tempemail = Faker::Internet.email
  end
  usedemail << tempemail
  User.create!(
  name: tempname,
  password: "password",
  email: tempemail,
  userpic: "https://robohash.org/#{rand(10000)}",
  bio: Faker::Hipster.sentence
  )
end

chirps = 300.times.map do
  Chirp.create!(
  body: Faker::StarWars.quote,
  user: users.sample
  )
end

300.times do
  user1 = users.sample
  user2 = nil
  while user2.blank? || user2 == user1
    user2 = users.sample
  end
  user1.follow!(user2)
end
