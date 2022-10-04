class CommentsController < ApplicationController
  respond_to :JSON
  before_action :process_token
  before_action :set_page, only: [:index]

  def index

    @comments = Comment.order('id DESC').limit(25).offset(@page_number * 25)

    # Adjust the data block to include items and reduce API calls
    @current_comments = []
    @comments.each do |comment|
      comment = comment.as_json
      comment[:user_name] = comment.user.name
      comment[:user_average_rating] = comment.user.average_rating
      @current_comments.push(comment)
    end

    render json: {message: "Comments #{@comments.last.id} - #{@comments.first.id}.", comments: @current_comments.as_json}, status: :ok
  end

  def show
    @comment = Comment.find(params[:id])
    if @comment.present?
      render json: {message: "Comment #{@comment.id}.", comment: {id: @comment.id, message: @comment.message, user_id: @comment.user_id, post_id: @comment.post_id, user_name: @comment.user.name, user_average_rating: @comment.user.user_average_rating, commented_at: @comment.commented_at, created_at: @comment.created_at, updated_at: @comment.updated_at} }, status: :ok
    else
      render json: {message: "Comment #{@comment.id} not found."}, status: :not_found
    end
  end

  def create
    updated_params = comment_params
    updated_params[:user_id] = @current_user_id
    updated_params[:commented_at] = Time.now
    @comment = Comment.new(updated_params)
    if @comment.save
      render json: {message: "Your comment has been created. ID: #{@comment.id}" }, status: :created
    else
      render json: {message: 'Error, your comment was not created.' }, status: :internal_server_error
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.present?
      if @comment.user_id == @current_user_id
        if @comment.update(comment_params)
          render json: {message: "Your comment has been updated. ID: #{@comment.id}" }, status: :ok
        else
          render json: {message: "Error, there was a problem updating this comment." }, status: :internal_server_error
        end
      else
        render json: {message: "Error, you don't have permission to update this comment." }, status: :unauthorized
      end
    else
      render json: {message: "Comment #{@comment.id} not found."}, status: :not_found
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.present?
      if @comment.user_id == @current_user_id
        if @comment.destroy
          render json: {message: "Your comment has been deleted. ID: #{@comment.id}" }, status: :ok
        else
          render json: {message: "Error, there was a problem deleting this comment." }, status: :internal_server_error
        end
      else
        render json: {message: "Error, you don't have permission to delete this comment." }, status: :unauthorized
      end
    else
      render json: {message: "Comment #{@comment.id} not found."}, status: :not_found
    end
  end

 private

  def set_page
    @page_number = params[:page].to_i || 0
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(
      :message,
      :post_id,
      :user_id
    )
  end
end
