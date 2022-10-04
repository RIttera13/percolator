class CurrentUserController < ApplicationController
  respond_to :JSON
  before_action :authenticate_user!

# This is a placeholder for future use to request the currently users information.

  def index
    render json: current_user, status: :ok
  end
end
