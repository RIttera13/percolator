class CurrentUserController < ApplicationController
  respond_to :JSON
  before_action :process_token
  before_action :authenticate_user!

  # This is a placeholder for future use to request the currently users information.

  def index
    render json: { user: User.find(@current_user_id) }, status: :ok
  end
end
