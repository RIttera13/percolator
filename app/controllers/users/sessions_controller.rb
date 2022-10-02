class Users::SessionsController < Devise::SessionsController
  respond_to :JSON

  private

  def response_with(resource, _ops = {})
    render json: {message: 'Logged In.' }, status: :ok
  end

  def respond_on_destroy
    current_user ? log_out_success : log_out_failure
  end

  def log_out_success
    render json: { message: "Logged out." }, status: :ok
  end

  def log_out_failure
    render json: { message: "Log out failure."}, status: :unauthorized
  end
end
