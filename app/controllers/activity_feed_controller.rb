class ActivityFeedController < ApplicationController
  respond_to :JSON
  before_action :process_token
  before_action :set_page
  before_action :authenticate_user!

  def show
    begin
      @current_user = User.find(@current_user_id)
      @activity_list = SortActivityFeed.call(@current_user, @page_number)
      if @activity_list[:activities].nil?
        # Return "No Content" when there are no activites to send.
        render json: {message: "Not more activities.", activity_list: {}.as_json, page_number: @activity_list[:page_number]}, status: :ok
      else
        render json: {message: "Activitys #{@activity_list[:activity_number_start]} - #{@activity_list[:activity_number_end]}", activity_list: @activity_list[:activities].as_json, page_number: @activity_list[:page_number]}, status: :ok
      end
    rescue => error
      # Errors will be handled by sending a 500 internal server error respons.
      render json: {message: 'Error, your activity feed is not available right now.', errors: error }, status: :internal_server_error
    end
  end

 private

  def set_page
    @page_number = activity_feed_params[:page].present? ? activity_feed_params[:page].to_i : 1
  end

  # Only allow a list of trusted parameters through.
  def activity_feed_params
    params.require(:activity_feed).permit(
      :page
    )
  end
end
