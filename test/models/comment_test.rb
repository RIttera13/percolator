require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  test "invalid if new comment is missing a message." do
    User.create(name: "Test", password: "testuser", email: "test3@email.com", github_username: "test3githubname").save
    user = User.last
    Post.create(title: "Test", body: "Body of posts", posted_at: Time.now, user_id: user.id).save
    post = Post.last
    comment = post.comments.create(message: nil, commented_at: Time.now, user_id: user.id)
    assert_not comment.valid?
  end

  test "invalid if new comment is missing a user_id." do
    User.create(name: "Test", password: "testuser", email: "test3@email.com", github_username: "test3githubname").save
    user = User.last
    Post.create(title: "Test", body: "Body of posts", posted_at: Time.now, user_id: user.id).save
    post = Post.last
    comment = post.comments.create(message: "Test, comment message", commented_at: Time.now, user_id: nil)
    assert_not comment.valid?
  end

  test "invalid if new comment is missing a commented_at time." do
    User.create(name: "Test", password: "testuser", email: "test3@email.com", github_username: "test3githubname").save
    user = User.last
    Post.create(title: "Test", body: "Body of posts", posted_at: Time.now, user_id: user.id).save
    post = Post.last
    comment = post.comments.create(message: "Test, comment message", commented_at: nil, user_id: user.id)
    assert_not comment.valid?
  end

  test "invalid if new comment is missing a post_id." do
    User.create(name: "Test", password: "testuser", email: "test3@email.com", github_username: "test3githubname").save
    user = User.last
    Post.create(title: "Test", body: "Body of posts", posted_at: Time.now, user_id: user.id).save
    post = Post.last
    comment = Comment.create(message: "Test, comment message", commented_at: Time.now, user_id: user.id, post_id: nil)
    assert_not comment.valid?
  end

  test "Valid if new comment has message, commented at time, a post id, and user id." do
    User.create(name: "Test", password: "testuser", email: "test3@email.com", github_username: "test3githubname").save
    user = User.last
    Post.create(title: "Test", body: "Body of posts", posted_at: Time.now, user_id: user.id).save
    post = Post.last
    comment = post.comments.create(message: "Test, comment message", commented_at: Time.now, user_id: user.id)
    assert comment.valid?
  end

end
