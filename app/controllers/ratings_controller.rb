class RatingsController < ApplicationController
  respond_to :JSON
  before_action :process_token
  before_action :set_page, only: [:index]

  def index
    @current_ratings = []
    @ratings = Rating.order('id DESC').limit(25).offset(@page_number * 25)

    @ratings.each do |rating|
      name = rating.user.name
      rating = rating.as_json
      rating[:user_name] = name
      @current_ratings.push(rating)
    end

    render json: {message: "Ratings #{@ratings.last.id} - #{@ratings.first.id}.", ratings: @current_ratings.as_json}, status: :ok
  end

  def show
    @rating = Rating.find(params[:id])
    if @rating.present?
      render json: {message: "Ratings #{@rating.id}.", rating: {id: @rating.id, user_id: @rating.user_id, rater_id: @rating.rater_id, user_name: @rating.user.name, rating: @rating.rating, rated_at: @rating.rated_at, created_at: @rating.created_at, updated_at: @rating.updated_at} }, status: :ok
    else
      render json: {message: "Ratings #{@rating.id} not found."}, status: :not_found
    end
  end

  def create
    updated_params = rating_params
    updated_params[:user_id] = @current_user_id
    updated_params[:rated_at] = Time.now
    @rating = Rating.new(updated_params)
    if @rating.save
      render json: {message: "You rated #{@rating.user.name} a #{@rating.rating}." }, status: :created
    else
      render json: {message: 'Error, your rating was not created.' }, status: :internal_server_error
    end
  end

  def update
    @rating = Rating.find(params[:id])
    if @rating.present?
      if @rating.user_id == @current_user_id
        if @rating.update(rating_params)
          render json: {message: "Your rating has been updated. #{@rating.user.name} is now a #{@rating.rating}" }, status: :ok
        else
          render json: {message: "Error, there was a problem updating this rating." }, status: :internal_server_error
        end
      else
        render json: {message: "Error, you don't have permission to update this rating." }, status: :unauthorized
      end
    else
      render json: {message: "Rating #{@rating.id} not found."}, status: :not_found
    end
  end

  def destroy
    @rating = Rating.find(params[:id])
    if @rating.present?
      if @rating.user_id == @current_user_id
        if @rating.destroy
          render json: {message: "Your rating has been deleted. ID: #{@rating.id}" }, status: :ok
        else
          render json: {message: "Error, there was a problem deleting this rating." }, status: :internal_server_error
        end
      else
        render json: {message: "Error, you don't have permission to delete this rating." }, status: :unauthorized
      end
    else
      render json: {message: "Rating #{@rating.id} not found."}, status: :not_found
    end
  end

 private

  def set_page
    @page_number = params[:page].to_i || 0
  end

  # Only allow a list of trusted parameters through.
  def rating_params
    params.require(:rating).permit(
      :rating,
      :user_id,
      :rating_id
    )
  end
end
