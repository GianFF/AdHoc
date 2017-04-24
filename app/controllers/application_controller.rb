class ApplicationController < ActionController::Base
  layout "application"
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:nombre, :apellido, :sexo])
      devise_parameter_sanitizer.permit(:account_update, keys: [:nombre, :apellido, :sexo])
  end
end
