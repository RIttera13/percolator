require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "invalid if new user is missing a first name." do
    user = User.create(first_name: nil, last_name: "User", username: "test1", password: "testuser", email: "test1@email.com")
    assert_not user.valid?
  end

  test "invalid if new user is missing a last name." do
    user = User.create(first_name: "Test", last_name: nil, username: "test2", password: "testuser", email: "test2@email.com")
    assert_not user.valid?
  end

  test "invalid if new user is missing a username." do
    user = User.create(first_name: "Test", last_name: "User", username: nil, password: "testuser", email: "test3@email.com")
    assert_not user.valid?
  end

  test "invalid if new user is missing an email address." do
    user = User.create(first_name: "Test", last_name: "User", username: "test4", password: "testuser", email: nil)
    assert_not user.valid?
  end

  test "valid if new user is has first name, last name, username, and email address." do
    user = User.create(first_name: "Test", last_name: "User", username: "test5", password: "testuser", email: "test5@email.com")
    assert user.valid?
  end
end
