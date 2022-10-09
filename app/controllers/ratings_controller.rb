class RatingsController < ApplicationController
  respond_to :JSON
  before_action :process_token
  before_action :set_page, only: [:index]
  before_action :set_user_id, only: [:index]
  before_action :set_rater_id, only: [:index]
  before_action :authenticate_user!, :except => [:index]

  def index

    @ratings = GetRatings.call(@page_number)

    # Adjust the data block to include items and reduce API calls
    @current_ratings = []
    @ratings[:ratings].each do |rating|
      user_name = rating.user.name
      rater_name = rating.rater.name
      rating = rating.as_json
      rating[:user_name] = user_name
      rating[:rater_name] = rater_name
      @current_ratings.push(rating)
    end
    starting_number = (@ratings[:page_number].to_i * 25) - 24

    render json: {message: "Ratings #{starting_number} - #{starting_number + (@ratings[:ratings].count - 1)}.", ratings: @current_ratings.as_json, page_number: @ratings[:page_number]}, status: :ok
  end

  def show
    # Optimized by including user in first call
    @rating = Rating.includes(:user).find(params[:id])
    if @rating.present?
      render json: { rating: {id: @rating.id, user_id: @rating.user_id, rater_id: @rating.rater_id, user_name: @rating.user.name, rating: @rating.rating, rated_at: @rating.rated_at, created_at: @rating.created_at, updated_at: @rating.updated_at} }, status: :ok
    else
      render json: { message: "Ratings #{@rating.id} not found." }, status: :not_found
    end
  end

  def create
    # Check if user id matches the rater id, we don't allow users to rate themselves
    if rating_params[:user_id] != @current_user_id

      # Check if user has already received a rating from the rater and delete any matching objects
      existing_rating = Rating.where(user_id: rating_params[:user_id]).where(rater_id: rating_params[:rater_id])
      if existing_rating.present?
        # Changed to destroy to allow accurate counter_cache number, delete method will not update the counter_cache
        existing_rating.each do |rating|
          Rating.find(rating.id).destroy
        end
      end

      # Refactored to one line and reduced number of steps
      @rating = Rating.new(rater_id: @current_user_id, rated_at: Time.now, user_id: rating_params[:user_id], rating: rating_params[:rating])
      if @rating.save

        # On creation of a new rating, we update the average rating for the user that received the rating
        update_user_average_rating(@rating.user)

        render json: {message: "You rated #{@rating.user.name} a #{@rating.rating}. ID: #{@rating.id}" }, status: :created
      else
        render json: {message: 'Error, your rating was not created.' }, status: :internal_server_error
      end
    else
      render json: {message: 'Error, your may not rate yourself.' }, status: :not_acceptable
    end
  end

  def update
    @rating = Rating.includes(:user).find(params[:id]) #Optimized by includeing user to first call
    if @rating.present?
      if @rating.rater_id == @current_user_id
        if @rating.update(rating_params)

          # On update of a rating, we update the average rating for the user that received the rating
          update_user_average_rating(@rating.user)

          render json: {message: "Your rating has been updated. #{@rating.user.name} is now a #{@rating.rating}. ID: #{@rating.id}" }, status: :ok
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
    @rating = Rating.includes(:user).find(params[:id]) #Optimized by includeing user to first call
    if @rating.present?
      if @rating.rater_id == @current_user_id
        if @rating.destroy

          # On Delete of a rating, we update the average rating for the user that received the rating
          update_user_average_rating(@rating.user)

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

  # Method to update a users average rating and when they passed 4 stars
  def update_user_average_rating(user)
    user.update(average_rating: @rating.user.ratings.average(:rating).to_f)
    if user.average_rating >= 4
      user.update(passed_four_stars: Time.now)
    else
      user.update(passed_four_stars: nil)
    end
  end

 private

  def set_page
    @page_number = rating_params[:page].present? ? rating_params[:page].to_i : 1
  end

  def set_user_id
    @user_id = rating_params[:user_id].present? ? rating_params[:user_id].to_i : ""
  end

  def set_rater_id
    @rater_id = rating_params[:rater_id].present? ? rating_params[:rater_id].to_i : ""
  end

  # Only allow a list of trusted parameters through.
  def rating_params
    params.require(:rating).permit(
      :rating,
      :user_id,
      :rater_id,
      :page
    )
  end
end
