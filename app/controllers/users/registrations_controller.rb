class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :JSON

  def create
    updated_params = user_params
    updated_params[:registered_at] = Time.now

    build_resource(updated_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      token = resource.generate_jwt
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  private

  def respond_with(resource, _opts = {})
   resource.persisted? ? register_success : register_failed
  end

  def register_success
   render json: { message: 'Welcome to Percolator.' }
  end

  def register_failed
   render json: { message: "Oh no! Something went wrong." }
  end

  def sign_up_params
   params.require(:user).permit(:name, :github_username, :email, :password, :password_confirmation)
  end

  def user_params
    params.require(:user).permit(
      :name,
      :github_username,
      :email,
      :password
    )
  end
end
