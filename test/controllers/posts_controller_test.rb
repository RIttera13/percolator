require 'test_helper'

class PostsControllerTest < ActionController::TestCase
  def setup
    User.create(name: "Test", password: "testuser", email: "test3@email.com", github_username: "test3githubname").save
    @post = Post.create(title: 'Test Post', body: "Body of test post.", user_id: User.last.id, posted_at: Time.now).save

  end

  def test_index
    get :index, params: { post: { page: 1 } }
    assert_response :success
    assert_match /Posts/, JSON.parse(@response.body)["message"]
    assert JSON.parse(@response.body)["posts"].present?
    assert_match "Test Post", JSON.parse(@response.body)["posts"].first["title"]
  end
end
