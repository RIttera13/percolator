class CommentsController < ApplicationController
  respond_to :JSON
  before_action :process_token
  before_action :set_page, only: [:index]
  before_action :set_user_id, only: [:index]
  before_action :set_post_id, only: [:index]
  before_action :authenticate_user!, :except => [:index]

  def index

    @comments = GetComments.call(@page_number)

    # Adjust the data block to include items and reduce API calls
    @current_comments = []
    @comments[:comments].each do |comment|
      user_name = comment.user.name
      average_rating = comment.user.average_rating.to_f.round(1)
      comment = comment.as_json
      comment[:user_name] = user_name
      comment[:user_average_rating] = average_rating
      @current_comments.push(comment)
    end
    starting_number = (@comments[:page_number].to_i * 25) - 24

    render json: {message: "Comments #{starting_number} - #{starting_number + (@comments[:comments].count - 1)}.", comments: @current_comments.as_json, page_number: @comments[:page_number]}, status: :ok
  end

  def show
    @comment = Comment.includes(:user).find(params[:id]) #Optimized by includeing user to first call
    if @comment.present?
      render json: { comment: {id: @comment.id, message: @comment.message, user_id: @comment.user_id, post_id: @comment.post_id, user_name: @comment.user.name, user_average_rating: @comment.user.average_rating.to_f.round(1), commented_at: @comment.commented_at, created_at: @comment.created_at, updated_at: @comment.updated_at} }, status: :ok
    else
      render json: { message: "Comment #{@comment.id} not found." }, status: :not_found
    end
  end

  def create
    # Refactored to use one line and reduce steps.
    @comment = Comment.new(user_id: @current_user_id, commented_at: Time.now, message: comment_params[:message], post_id: comment_params[:post_id])
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
    @page_number = comment_params[:page].present? ? comment_params[:page].to_i : 1
  end

  def set_user_id
    @user_id = comment_params[:user_id].present? ? comment_params[:user_id].to_i : ""
  end

  def set_post_id
    @post_id = comment_params[:post_id].present? ? comment_params[:post_id].to_i : ""
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(
      :message,
      :post_id,
      :user_id,
      :page
    )
  end
end
