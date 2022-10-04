class ActivityFeedController < ApplicationController
  respond_to :JSON
  before_action :process_token
  before_action :set_page, only: [:show]
  before_action :authenticate_user!

  def show
    begin
      @activity_list = SortActivityFeed.call(@current_user)
      render json: {message: "Activitys #{1} - #{activity_list.count}", activity_list: @activity_list.as_json}, status: :ok
    rescue => error
      render json: {message: 'Error, your activity feed is not available right nom.', errors: error }, status: :internal_server_error
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
