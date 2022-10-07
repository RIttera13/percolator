require 'test_helper'

class GetCommentsTest < ActiveSupport::TestCase
  def setup
    (0..5).each do |user_index|
      User.create(name: "Test_#{user_index}", password: "testuser", email: "test_#{user_index}@email.com", github_username: "test3githubname").save
    end
    @user_1 = User.first.id
    @user_2 = User.last.id

    User.all.each do |user|
      (0..5).each do |post_index|
        Post.create(title: "Test #{post_index}", body: "Body of post #{post_index}", posted_at: Time.now, user_id: user.id).save
      end
    end
    @post_1 = Post.first.id
    @post_2 = Post.last.id

    Post.all.each do |post|
      (0..55).each do |comment_index|
        post.comments.create(message: "Comment #{comment_index} for Post #{post.id}", commented_at: Time.now, user_id: User.pluck(:id).sample)
      end
    end

    @comment_1 = Comment.first.id
    @comment_2 = Comment.last.id
  end

  test "Valid if GetComments call containing no arguments is sent." do
    response = GetComments.call()
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:comments].is_a?(ActiveRecord::Relation)
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetComments call containing only positive page_number is sent." do
    response = GetComments.call(1, "", "")
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:comments].is_a?(ActiveRecord::Relation)
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetComments call containing only page_number 2 is sent." do
    response = GetComments.call(2, "", "")
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:comments].is_a?(ActiveRecord::Relation)
    assert response[:page_number].to_i == 2
  end

  test "Valid if GetComments call containing negative page_number will receive first page." do
    response_positve = GetComments.call(1, "", "")
    response_negative = GetComments.call(-1, "", "")
    assert response_negative.present?
    assert response_negative.is_a?(Hash)
    assert response_negative[:comments].is_a?(ActiveRecord::Relation)
    assert response_negative[:page_number].to_i == 1
    assert response_positve[:comments] == response_negative[:comments]
  end

  test "Valid if GetComments call containing only user_id." do
    response = GetComments.call(nil , @user_1, "")
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:comments].is_a?(ActiveRecord::Relation)
    assert response[:comments].pluck(:user_id).uniq.count == 1
    assert response[:comments].pluck(:user_id).first == @user_1
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetComments call containing page_number and user_id." do
    response = GetComments.call(1, @user_1, "")
    assert response.is_a?(Hash)
    assert response[:comments].is_a?(ActiveRecord::Relation)
    assert response[:comments].pluck(:user_id).uniq.count == 1
    assert response[:comments].pluck(:user_id).first == @user_1
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetComments call containing page_number 2 and user_id." do
    response = GetComments.call(2, @user_1, "")
    assert response.is_a?(Hash)
    assert response[:comments].is_a?(ActiveRecord::Relation)
    assert response[:comments].pluck(:user_id).uniq.count == 1
    assert response[:comments].pluck(:user_id).first == @user_1
    assert response[:page_number].to_i == 2
  end

  test "Valid if GetComments call containing only post_id." do
    response = GetComments.call("", "", @post_1)
    assert response.is_a?(Hash)
    assert response[:comments].is_a?(ActiveRecord::Relation)
    assert response[:comments].pluck(:post_id).uniq.count == 1
    assert response[:comments].pluck(:post_id).first == @post_1
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetComments call containing page_number and post_id." do
    response = GetComments.call(1, "", @post_1)
    assert response.present?
    assert response[:comments].is_a?(ActiveRecord::Relation)
    assert response[:comments].pluck(:post_id).uniq.count == 1
    assert response[:comments].pluck(:post_id).first == @post_1
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetComments call containing page_number 2 and post_id." do
    response = GetComments.call(2, "", @post_1)
    assert response.present?
    assert response[:comments].is_a?(ActiveRecord::Relation)
    assert response[:comments].pluck(:post_id).uniq.count == 1
    assert response[:comments].pluck(:post_id).first == @post_1
    assert response[:page_number].to_i == 2
  end

  test "Fail if GetComments call containing page_number and user_id and post_id." do
    response = GetComments.call(1, @user_1, @post_1)
    assert response.present?
    assert_match "Please send user_id OR post_id, not both.", response[:error]
  end

end
