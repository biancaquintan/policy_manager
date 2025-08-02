module Users
  # app/controllers/users/sessions_controller.rb
  class SessionsController < Devise::SessionsController
    respond_to :json

    skip_before_action :verify_authenticity_token, if: -> { request.format.json? }

    private

    def respond_with(resource, _opts = {})
      token = current_token
      if resource.persisted? && token.present?
        render json: {
          message: 'Login successful',
          user: resource,
          token: token
        }, status: :ok
      else
        render json: {
          message: 'Login failed',
          errors: ['Invalid login or token not generated']
        }, status: :unauthorized
      end
    end

    def current_token
      request.env['warden-jwt_auth.token']
    end

    def respond_to_on_destroy
      head :no_content
    end
  end
end
