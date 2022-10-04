# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
(1..100).each do |index|
  User.create(
    name: "User_#{index}",
    github_username: "GitHub_#{index}",
    email: "email_#{index}@test.com"
  ).save!

  puts "Created User_#{index}"
end

User.all.each do |user|
  count = rand(10)
  (1..count).each do |index|
    user.posts.create(
      title: "Title for Post #{index}",
      body: "Body for post #{index}",
      posted_at: Time.now - index
    ).save!

    puts "Created Post #{index} - #{user.name}"
  end

  5.times do
    other_user = User.where.not(id: user.id).sample
    rating = [1, 2, 3, 4, 5].sample
    Rating.create(user_id: user.id, rater_id: other_user.id, rating: rating, rated_at: Time.now).save!

    puts "Created Rating #{user.name} rated #{other_user.name} - #{rating}"
  end
end

Post.all.each do |post|
 count = rand(10)
 (1..count).each do |index|
   post.comments.create(
     user_id: User.pluck(:id).sample,
     message: "This is the comment message #{index} for Post #{post.id}.",
     commented_at: Time.now - index
   ).save!

   puts "Created Comment #{index} for Post #{post.id}"
 end
end
