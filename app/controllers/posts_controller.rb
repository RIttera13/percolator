class PostsController < ApplicationController
  respond_to :JSON
  before_action :process_token
  before_action :set_page, only: [:index]

  def index
    @current_posts = []
    @posts = Post.order('id DESC').limit(25).offset(@page_number * 25)

    @posts.each do |post|
      name = post.user.name
      post = post.as_json
      post[:user_name] = name
      @current_posts.push(post)
    end

    render json: {message: "Posts #{@posts.last.id} - #{@posts.first.id}.", posts: @current_posts.as_json}, status: :ok
  end

  def show
    @post = Post.find(params[:id])
    if @post.present?
      render json: {message: "Post #{@post.id}.", posts: {id: @post.id, title: @post.title, body: @post.body, user_id: @post.user_id, user_name: @post.user.name, posted_at: @post.posted_at, created_at: @post.created_at, updated_at: @post.updated_at} }, status: :ok
    else
      render json: {message: "Post #{@post.id} not found."}, status: :not_found
    end
  end

  def create
    updated_params = post_params
    updated_params[:user_id] = @current_user_id
    updated_params[:posted_at] = Time.now
    @post = Post.new(updated_params)
    if @post.save
      render json: {message: "Your post has been created. ID: #{@post.id}" }, status: :created
    else
      render json: {message: 'Error, your post was not created.' }, status: :internal_server_error
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.present?
      if @post.user_id == @current_user_id
        if @post.update(post_params)
          render json: {message: "Your post has been updated. ID: #{@post.id}" }, status: :ok
        else
          render json: {message: "Error, there was a problem updating this post." }, status: :internal_server_error
        end
      else
        render json: {message: "Error, you don't have permission to update this post." }, status: :unauthorized
      end
    else
      render json: {message: "Post #{@post.id} not found."}, status: :not_found
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.present?
      if @post.user_id == @current_user_id
        if @post.destroy
          render json: {message: "Your post has been deleted. ID: #{@post.id}" }, status: :ok
        else
          render json: {message: "Error, there was a problem deleting this post." }, status: :internal_server_error
        end
      else
        render json: {message: "Error, you don't have permission to delete this post." }, status: :unauthorized
      end
    else
      render json: {message: "Post #{@post.id} not found."}, status: :not_found
    end
  end

 private

  def set_page
    @page_number = params[:page].to_i || 0
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(
      :title,
      :body,
      :user_id
    )
  end
end
