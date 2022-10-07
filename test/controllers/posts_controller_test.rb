require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  include Devise::Test::IntegrationHelpers

  def setup
    # Ensure sufficient database entries exist to complete tests
    (0..10).each do |user_index|
      User.create(name: "Test_#{user_index}", password: "testuser", email: "test_#{user_index}@email.com", github_username: "test3githubname").save
    end
    @user_1 = User.first

    User.all.each do |user|
      (0..20).each do |post_index|
        Post.create(title: "Test Post #{post_index}", body: "Body of post #{post_index}", posted_at: Time.now, user_id: user.id).save
      end
    end
    @post_1 = Post.first
  end

  test "Valid if Get Post Index is successful with no page number passed." do
    get :index, params: { post: { page: "" } }
    assert_response :success
    assert_match /Posts/, JSON.parse(@response.body)["message"]
    assert JSON.parse(@response.body)["posts"].present?
    assert_match /Test Post/, JSON.parse(@response.body)["posts"].first["title"]
    assert_match /Body of post/, JSON.parse(@response.body)["posts"].first["body"]
    assert JSON.parse(@response.body)["posts"].first["posted_at"].present?
    assert JSON.parse(@response.body)["page_number"].to_i == 1
  end

  test "Valid if Get Post Index is successful with positive page number passed." do
    get :index, params: { post: { page: 1 } }
    assert_response :success
    assert_match /Posts/, JSON.parse(@response.body)["message"]
    assert JSON.parse(@response.body)["posts"].present?
    assert_match /Test Post/, JSON.parse(@response.body)["posts"].first["title"]
    assert_match /Body of post/, JSON.parse(@response.body)["posts"].first["body"]
    assert JSON.parse(@response.body)["posts"].first["posted_at"].present?
    assert JSON.parse(@response.body)["page_number"].to_i == 1
  end

  test "Valid if Get Post Index is successful with negative page number passed and equals page number 1." do
    get :index, params: { post: { page: 1 } }
    assert_response :success
    positive_page_number = @response.body

    get :index, params: { post: { page: -1 } }
    assert_response :success
    negative_page_number = @response.body

    assert negative_page_number == positive_page_number
  end

  test "Valid if Get Post Index is successful with page number 2 passed." do
    get :index, params: { post: { page: 2 } }
    assert_response :success
    assert_match /Posts/, JSON.parse(@response.body)["message"]
    assert JSON.parse(@response.body)["posts"].present?
    assert_match /Test Post/, JSON.parse(@response.body)["posts"].first["title"]
    assert_match /Body of post/, JSON.parse(@response.body)["posts"].first["body"]
    assert JSON.parse(@response.body)["posts"].first["posted_at"].present?
    assert JSON.parse(@response.body)["page_number"].to_i == 2
  end

end
