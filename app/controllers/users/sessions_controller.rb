class Users::SessionsController < Devise::SessionsController
  respond_to :JSON

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

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
