class ActivityFeedController < ApplicationController
  respond_to :JSON
  before_action :process_token
  before_action :set_page, only: [:show]
  before_action :authenticate_user!

  def show

    @posts = GetPosts.call(@page_number, @current_user)
    @comments = GetComments.call(@page_number, @current_user)
    @ratings = GetRatings.call(@page_number, @current_user)
    @github_events = GetGithubUserEvents.call(@page_number, @current_user)
binding.pry
    if 1 > 0
      render json: {message: "Success Message."}, status: :ok
    else
      render json: {message: "Error Message."}, status: :not_found
    end
  end

 private

  def set_page
    @page_number = params[:page].to_i || 0
  end

  # Only allow a list of trusted parameters through.
  def activity_feed_params
    params.require(:activity_feed).permit(
      :user_id
    )
  end
end
