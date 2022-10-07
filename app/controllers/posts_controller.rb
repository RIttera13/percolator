class PostsController < ApplicationController
  respond_to :JSON
  before_action :process_token
  before_action :set_page, only: [:index, :get_comments_for_post]
  before_action :set_user_id, only: [:index, :get_comments_for_post]
  before_action :set_post_id, only: [:index, :get_comments_for_post]
  before_action :authenticate_user!, :except => [:index]

  def index
    @posts = GetPosts.call(@page_number)

    # Adjust the data block to include items and reduce API calls
    @current_posts = []
    @posts[:posts].each do |post|
      user_name = post.user.name
      average = post.user.average_rating.to_f.round(1)
      comment_count = post.comments.count
      post = post.as_json
      post[:user_name] = user_name
      post[:user_rating] = average
      post[:comment_count] = comment_count
      @current_posts.push(post)
    end
    starting_number = (@posts[:page_number].to_i * 25) - 24

    render json: { message: "Posts #{starting_number} - #{starting_number + (@posts[:posts].count - 1)}.", posts: @current_posts.as_json, page_number: @posts[:page_number]}, status: :ok
  end

  def show
    @post = Post.includes(:comments).find(params[:id])
    if @post.present?
      @comment_count = 0
      @comments = @post.comments.limit(25)

      # Compile the needed attirbutes to reduce API calls.
      if @comments.present?
        comment_count = @comments.count
        set_comment_data(@comments)
      end

      # Comments are limited to 25. This corresponds to the 'GetComments' for proper pagination
      render json: { post: {id: @post.id, title: @post.title, body: @post.body, user_id: @post.user_id, user_name: @post.user.name, user_rating: @post.user.average_rating.to_f.round(1), comments: @compiled_comments, comment_count: @comment_count, posted_at: @post.posted_at, created_at: @post.created_at, updated_at: @post.updated_at } }, status: :ok
    else
      render json: { message: "Post #{@post.id} not found." }, status: :not_found
    end
  end

  def create
    updated_params = post_params
    updated_params[:user_id] = @current_user_id
    updated_params[:posted_at] = Time.now
    @post = Post.new(updated_params)
    if @post.save
      render json: { message: "Your post has been created. ID: #{@post.id}" }, status: :created
    else
      render json: { message: 'Error, your post was not created.' }, status: :internal_server_error
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.present?
      if @post.user_id == @current_user_id
        if @post.update(post_params)
          render json: { message: "Your post has been updated. ID: #{@post.id}" }, status: :ok
        else
          render json: { message: "Error, there was a problem updating this post." }, status: :internal_server_error
        end
      else
        render json: { message: "Error, you don't have permission to update this post." }, status: :unauthorized
      end
    else
      render json: { message: "Post #{@post.id} not found." }, status: :not_found
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.present?
      if @post.user_id == @current_user_id
        if @post.destroy
          render json: { message: "Your post has been deleted. ID: #{@post.id}" }, status: :ok
        else
          render json: { message: "Error, there was a problem deleting this post." }, status: :internal_server_error
        end
      else
        render json: { message: "Error, you don't have permission to delete this post." }, status: :unauthorized
      end
    else
      render json: { message: "Post #{@post.id} not found." }, status: :not_found
    end
  end

  def get_comments_for_post
    if post_params[:post_id].present?
      # Get comments for specific post
      @comments = GetComments.call(@page_number, "", post_params[:post_id])
      set_comment_data(@comments)
      starting_number = (@page_number * 25) - 24
      render json: { message: "Comments #{starting_number} - #{starting_number + (@compiled_comments.count - 1)}.", post_id: post_params[:post_id], comments: @compiled_comments, page_number: @page_number}, status: :ok
    else
      render json: { message: "Missing 'post_id'." }, status: :bad_request
    end
  end

 private

  def set_page
    @page_number = post_params[:page].present? ? post_params[:page].to_i : 1
  end

  def set_user_id
    @user_id = post_params[:user_id].present? ? post_params[:user_id].to_i : ""
  end

  def set_post_id
    @post_id = post_params[:post_id].present? ? post_params[:post_id].to_i : ""
  end

  def set_comment_data(comments)
    # Compile the needed attirbutes to reduce API calls.
    @compiled_comments = []
    comments[:comments].each do |comment|
      @compiled_comments.push(id: comment.id, message: comment.message, commented_at: comment.commented_at, user_name: comment.user.name, user_average_rating: comment.user.average_rating.to_f.round(1))
    end
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(
      :title,
      :body,
      :user_id,
      :post_id,
      :page
    )
  end
end
