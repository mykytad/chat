# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
if Rails.env.development?
  u = 0

  my_user = User.create!(
    name: Faker::JapaneseMedia::OnePiece.character,
    email: "nikita@example.com",
    phone: Faker::Number.number(digits: 10),
    password: "123456",
    password_confirmation: "123456"
  )

  while u < 50
    User.create!(
      name: Faker::JapaneseMedia::OnePiece.character,
      email: Faker::Internet.email,
      phone: Faker::Number.number(digits: 10),
      password: "123456",
      password_confirmation: "123456"
    )
    u += 1
  end

  puts "Users create"

  user_ids = []
  users = User.first(11)
  users.each do |user|
    user_ids << user.id
  end
  user_ids.shift

  d = 0
  user_ids.each do |id|
    Dialogue.create!(
      sender_id: my_user.id,
      recipient_id: id
    )
  end
  puts "Dialogues create"

  m = 0
  while m < 15
    Message.create!(
      body: Faker::Quote.matz,
      user_id: rand(1..25),
      dialogue_id: rand(1..10)
    )
    m += 1
  end

  puts "Messages create"
end
