require 'test_helper'

class GetGithubUserEventsTest < ActiveSupport::TestCase

  test "invalid if user is missing a github user_name." do
    user = User.create(name: nil, password: "testuser", email: "test1@email.com", github_username: nil)
    github_events = GetGithubUserEvents.call(user.github_username)
    assert_match "Not Found", github_events.message
  end

  test "Valid if user contains a github user_name, but returns empty array." do
    user = User.create(name: nil, password: "testuser", email: "test1@email.com", github_username: "tater")
    github_events = GetGithubUserEvents.call(user.github_username)
    assert_not github_events.present?
  end

  test "Valid if user contains a github user_name, and returns data." do
    user = User.create(name: nil, password: "testuser", email: "test1@email.com", github_username: "RIttera13")
    github_events = GetGithubUserEvents.call(user.github_username)
    assert github_events.present?
  end

end
