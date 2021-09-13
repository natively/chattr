# frozen_string_literal: true

# meta request stuff goes here
class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Exceptions::User::NotAuthorized, with: :deny_access

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  def deny_access(exception)
    @message = exception.message

    render 'error_pages/401', status: :unauthorized
  end
end
