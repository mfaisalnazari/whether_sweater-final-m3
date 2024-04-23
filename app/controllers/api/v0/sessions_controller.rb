class Api::V0::SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email])
    if user && user.authenticate(session_params[:password])
      render json: {
        data: {
          type: 'users',
          id: "#{user.id}",
          attributes: {
            email: user.email,
            api_key: user.api_key
          }
        }
      }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end
