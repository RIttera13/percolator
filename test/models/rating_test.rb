require 'test_helper'

class RatingTest < ActiveSupport::TestCase

  test "invalid if new rating is less than 1." do
    User.create(name: "User_1", password: "testuser", email: "test1@email.com", github_username: "test1githubname").save
    user = User.last
    User.create(name: "Rater_1", password: "testuser", email: "test2@email.com", github_username: "test2githubname").save
    rater = User.last
    rating = Rating.create(user_id: user.id, rater_id: rater.id, rating: 0)
    assert_not rating.valid?
  end

  test "invalid if new rating is greater than 5." do
    User.create(name: "User_1", password: "testuser", email: "test1@email.com", github_username: "test1githubname").save
    user = User.last
    User.create(name: "Rater_1", password: "testuser", email: "test2@email.com", github_username: "test2githubname").save
    rater = User.last
    rating = Rating.create(user_id: user.id, rater_id: rater.id, rating: 6)
    assert_not rating.valid?
  end

  test "Valid if new rating is between 1 and 5." do
    (1..5).each do |index|
      User.create(name: "User_#{index}1", password: "testuser", email: "test_#{index}@email.com", github_username: "test_#{index}githubname").save
      user = User.last
      User.create(name: "Rater_#{index}1", password: "testuser", email: "test_#{index}@email.com", github_username: "test_#{index}githubname").save
      rater = User.last
      rating = Rating.create(user_id: user.id, rater_id: rater.id, rating: index)
      assert rating.valid?
    end
  end
end
