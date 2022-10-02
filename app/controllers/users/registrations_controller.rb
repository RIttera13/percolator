class Users::RegistrationsController < Devise::RegistrationsController
 respond_to :JSON

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

end
