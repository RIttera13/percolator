class ApplicationController < ActionController::API

  def authenticate_user!(options = {})
    head :unauthorized unless signed_in?
  end

  def signed_in?
    @current_user_id.present?
  end

  def current_user
    @current_user ||= super || User.find(@current_user_id)
  end

  def process_token
    if request.headers['Authorization'].present?
      begin
        token = request.headers['Authorization'].split(' ')[1].remove('"')
        jwt_payload = Warden::JWTAuth::UserDecoder.new.call(token, :user, nil)
        @current_user_id = jwt_payload['id']
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        head :unauthorized
      end
    end
  end

end
