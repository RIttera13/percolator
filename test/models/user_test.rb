require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "invalid if new user is missing a name." do
    user = User.create(name: nil, password: "testuser", email: "test1@email.com")
    assert_not user.valid?
  end

  test "invalid if new user is missing an email address." do
    user = User.create(name: "Test User", password: "testuser", email: nil)
    assert_not user.valid?
  end

  test "valid if new user is has name and email address." do
    user = User.create(name: "Test", password: "testuser", email: "test3@email.com")
    assert user.valid?
  end

  test "valid if new user has github_username." do
    user = User.create(name: "Test", password: "testuser", email: "test3@email.com", github_username: "test3githubname")
    assert user.valid?
  end

end
