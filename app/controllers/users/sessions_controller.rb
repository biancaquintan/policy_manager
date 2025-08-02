module Users
  # app/controllers/users/sessions_controller.rb
  class SessionsController < Devise::SessionsController
    respond_to :json

    def create
      user = find_user

      if user&.valid_password?(login_params[:password])
        login_success(user)
      else
        login_failure
      end
    end

    def respond_to_on_destroy
      head :no_content
    end

    private

    def login_params
      params.require(:user).permit(:email, :password)
    end

    def find_user
      User.find_by(email: login_params[:email])
    end

    def login_success(user)
      sign_in(:user, user)
      render json: {
        message: 'Login successful',
        user: user,
        token: request.env['warden-jwt_auth.token']
      }, status: :ok
    end

    def login_failure
      render json: {
        message: 'Login failed',
        errors: ['Invalid email or password']
      }, status: :unauthorized
    end
  end
end
