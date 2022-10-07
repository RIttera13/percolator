require 'test_helper'

class GetRatingsTest < ActiveSupport::TestCase
  def setup
    (0..100).each do |user_index|
      User.create(name: "Test_#{user_index}", password: "testuser", email: "test_#{user_index}@email.com", github_username: "test3githubname").save
    end

    User.all.each do |user|
      50.times do
        other_user = User.where.not(id: user.id).sample
        rating = [1, 2, 3, 4, 5].sample
        Rating.create(user_id: user.id, rater_id: other_user.id, rating: rating, rated_at: Time.now).save
      end
    end

    @user_1 = User.first.id
    @user_2 = User.last.id
  end

  test "Valid if GetRatings call containing no arguments is sent." do
    response = GetRatings.call()
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:ratings].is_a?(ActiveRecord::Relation)
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetRatings call containing only positive page_number is sent." do
    response = GetRatings.call(1, "", "")
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:ratings].is_a?(ActiveRecord::Relation)
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetRatings call containing only page_number 2 is sent." do
    response = GetRatings.call(2, "", "")
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:ratings].is_a?(ActiveRecord::Relation)
    assert response[:page_number].to_i == 2
  end

  test "Valid if GetRatings call containing negative page_number will receive first page." do
    response_positve = GetRatings.call(1, "", "")
    response_negative = GetRatings.call(-1, "", "")
    assert response_positve.present?
    assert response_positve.is_a?(Hash)
    assert response_positve[:ratings].is_a?(ActiveRecord::Relation)
    assert response_negative.present?
    assert response_negative.is_a?(Hash)
    assert response_negative[:ratings].is_a?(ActiveRecord::Relation)
    assert response_negative[:page_number].to_i == 1
    assert response_positve[:ratings] == response_negative[:ratings]
  end

  test "Valid if GetRatings call containing only user_id." do
    response = GetRatings.call(nil , @user_1, "")
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:ratings].is_a?(ActiveRecord::Relation)
    assert response[:ratings].pluck(:user_id).uniq.count == 1
    assert response[:ratings].pluck(:user_id).first == @user_1
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetRatings call containing page_number and user_id." do
    response = GetRatings.call(1, @user_1, "")
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:ratings].is_a?(ActiveRecord::Relation)
    assert response[:ratings].pluck(:user_id).uniq.count == 1
    assert response[:ratings].pluck(:user_id).first == @user_1
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetRatings call containing page_number 2 and user_id." do
    response = GetRatings.call(2, @user_1, "")
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:ratings].is_a?(ActiveRecord::Relation)
    assert response[:ratings].pluck(:user_id).uniq.count == 1
    assert response[:ratings].pluck(:user_id).first == @user_1
    assert response[:page_number].to_i == 2
  end

  test "Valid if GetRatings call containing only rater_id." do
    response = GetRatings.call("", "", @user_2)
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:ratings].is_a?(ActiveRecord::Relation)
    assert response[:ratings].pluck(:rater_id).uniq.count == 1
    assert response[:ratings].pluck(:rater_id).first == @user_2
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetRatings call containing page_number and rater_id." do
    response = GetRatings.call(1, "", @user_2)
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:ratings].is_a?(ActiveRecord::Relation)
    assert response[:ratings].pluck(:rater_id).uniq.count == 1
    assert response[:ratings].pluck(:rater_id).first == @user_2
    assert response[:page_number].to_i == 1
  end

  test "Valid if GetRatings call containing page_number 2 and rater_id." do
    response = GetRatings.call(2, "", @user_2)
    assert response.present?
    assert response.is_a?(Hash)
    assert response[:ratings].is_a?(ActiveRecord::Relation)
    assert response[:ratings].pluck(:rater_id).uniq.count == 1
    assert response[:ratings].pluck(:rater_id).first == @user_2
    assert response[:page_number].to_i == 2
  end

  test "Fail if GetRatings call containing page_number and user_id and rater_id." do
    response = GetRatings.call(1, @user_1, @user_2)
    assert response.present?
    assert_match "Please send user_id OR rater_id, not both.", response[:error]
  end

end
