require 'test_helper'

class SortActivityTest < ActiveSupport::TestCase
  def setup
    # Ensure sufficient database entries exist to complete tests
    (0..10).each do |user_index|
      User.create(name: "Test_#{user_index}", password: "testuser", email: "test_#{user_index}@email.com", github_username: "test3githubname").save
    end
    @user_1 = User.first

    User.all.each do |user|
      5.times do
        other_user = User.where.not(id: user.id).sample
        rating = [1, 2, 3, 4, 5].sample
        Rating.create(user_id: user.id, rater_id: other_user.id, rating: rating, rated_at: Time.now).save
      end
    end

    User.all.each do |user|
      (0..5).each do |post_index|
        Post.create(title: "Test #{post_index}", body: "Body of post #{post_index}", posted_at: Time.now, user_id: user.id).save
      end
    end

    Post.all.each do |post|
      (0..5).each do |comment_index|
        post.comments.create(message: "Comment #{comment_index} for Post #{post.id}", commented_at: Time.now, user_id: User.pluck(:id).sample)
      end
    end

    (1..50).each do |index|
      @user_1.posts.create(title: "Test #{@user_1.name} Post #{index}", body: "Body of post #{index}", posted_at: Time.now)
      @user_1.comments.create(message: "Test #{@user_1.name} Comment #{index}", commented_at: Time.now, post_id: Post.pluck(:id).sample)
    end
  end

  test "Fail if SortActivityFeed call containing no arguments is sent." do
    begin
      response = SortActivityFeed.call()
    rescue ArgumentError
      response = "ArgumentError"
    end
    assert_match "ArgumentError", response
  end

  test "Fail if SortActivityFeed call containing only page_number is sent." do
    begin
      response = SortActivityFeed.call("", 1)
    rescue NoMethodError
      response = "NoMethodError"
    end
    assert_match "NoMethodError", response
  end

  test "Valid if SortActivityFeed call containing only user is sent." do
    response = SortActivityFeed.call(@user_1, "")
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:page_number] == 1
    assert response[:activity_number_start] == 1
    assert response[:activity_number_end] <= 50
    assert response[:activities].present?
    assert response[:activities].is_a?(Array)
    assert response[:activities].first.is_a?(Activity)
    assert response[:activities].first[:type].present?
    assert response[:activities].first[:data].present?
    assert response[:activities].first[:date].present?
  end

  test "Valid if SortActivityFeed call containing only user and page 2 is sent." do
    response = SortActivityFeed.call(@user_1, 2)
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:page_number] == 2
    assert response[:activity_number_start] == 51
    assert response[:activity_number_end] <= 100
    assert response[:activities].present?
    assert response[:activities].is_a?(Array)
    assert response[:activities].first.is_a?(Activity)
    assert response[:activities].first[:type].present?
    assert response[:activities].first[:data].present?
    assert response[:activities].first[:date].present?
  end

  test "Valid if SortActivityFeed call containing only user and page 100 is sent." do
    response = SortActivityFeed.call(@user_1, 100)
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:page_number] == 100
    assert response[:activity_number_start] == 4951
    assert response[:activity_number_end].nil?
    assert_not response[:activities].present?
  end

end
