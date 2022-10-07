require 'test_helper'

class GetPostsTest < ActiveSupport::TestCase
  def setup
    (0..5).each do |user_index|
      User.create(name: "Test_#{user_index}", password: "testuser", email: "test_#{user_index}@email.com", github_username: "test3githubname").save
    end
    @user_1 = User.first.id
    @user_2 = User.last.id

    User.all.each do |user|
      (0..55).each do |post_index|
        Post.create(title: "Test #{post_index}", body: "Body of post #{post_index}", posted_at: Time.now, user_id: user.id).save
      end
    end
    @post_1 = Post.first.id
    @post_2 = Post.last.id
  end

  test "Valid if GetPosts call containing no arguments is sent." do
    response = GetPosts.call()
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:posts].is_a?(ActiveRecord::Relation)
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetPosts call containing only positive page_number is sent." do
    response = GetPosts.call(1, "")
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:posts].is_a?(ActiveRecord::Relation)
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetPosts call containing only page_number 2 is sent." do
    response = GetPosts.call(2, "")
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:posts].is_a?(ActiveRecord::Relation)
    assert response[:page_number].to_i == 2
  end

  test "Valid if GetPosts call containing negative page_number will receive first page." do
    response_positve = GetPosts.call(1, "")
    response_negative = GetPosts.call(-1, "")
    assert response_positve.present?
    assert response_positve.is_a?(Hash)
    assert response_positve[:posts].is_a?(ActiveRecord::Relation)
    assert response_negative.present?
    assert response_negative.is_a?(Hash)
    assert response_negative[:posts].is_a?(ActiveRecord::Relation)
    assert response_negative[:page_number].to_i == 1
    assert response_positve[:posts] == response_negative[:posts]
  end

  test "Valid if GetPosts call containing only user_id." do
    response = GetPosts.call(nil , @user_1)
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:posts].is_a?(ActiveRecord::Relation)
    assert response[:posts].pluck(:user_id).uniq.count == 1
    assert response[:posts].pluck(:user_id).first == @user_1
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetPosts call containing page_number and user_id." do
    response = GetPosts.call(1, @user_1)
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:posts].is_a?(ActiveRecord::Relation)
    assert response[:posts].pluck(:user_id).uniq.count == 1
    assert response[:posts].pluck(:user_id).first == @user_1
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetPosts call containing page_number 2 and user_id." do
    response = GetPosts.call(2, @user_1)
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:posts].is_a?(ActiveRecord::Relation)
    assert response[:posts].pluck(:user_id).uniq.count == 1
    assert response[:posts].pluck(:user_id).first == @user_1
    assert response[:page_number].to_i == 2
  end

end
