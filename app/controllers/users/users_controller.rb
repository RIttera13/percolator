class UsersController < ApplicationController
  respond_to :JSON
  before_action :process_token

  def index
    users = User.all
  end

  def create
    binding.pry
    @user = User.new(user_params).save
    @user.update(registered_at: Time.now)
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
  end

  def destroy
    @user.destroy
  end

  private

    # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(
      :name,
      :github_username,
      :email,
      :password
    )
  end
end
