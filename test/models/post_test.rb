require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "invalid if new post is missing a title." do
    User.create(name: "Test", password: "testuser", email: "test3@email.com", github_username: "test3githubname").save
    user = User.last
    post = Post.create(title: nil, body: "Body of posts", posted_at: Time.now, user_id: user.id)
    assert_not post.valid?
  end

  test "invalid if new post is missing a body." do
    User.create(name: "Test", password: "testuser", email: "test3@email.com", github_username: "test3githubname").save
    user = User.last
    post = Post.create(title: "New Title", body: nil, posted_at: Time.now, user_id: user.id)
    assert_not post.valid?
  end

  test "invalid if new post is missing a posted at time." do
    User.create(name: "Test", password: "testuser", email: "test3@email.com", github_username: "test3githubname").save
    user = User.last
    post = Post.create(title: "New Title", body: "Body of posts", posted_at: nil, user_id: user.id)
    assert_not post.valid?
  end

  test "invalid if new post is missing a user id." do
    post = Post.create(title: "New Title", body: "Body of posts", posted_at: Time.now, user_id: nil)
    assert_not post.valid?
  end

  test "Valid if new post has title, body, posted at time, a user id." do
    User.create(name: "Test", password: "testuser", email: "test3@email.com", github_username: "test3githubname").save
    user = User.last
    post = Post.create(title: "New Title", body: "Body of posts", posted_at: Time.now, user_id: user.id)
    assert post.valid?
  end

end
