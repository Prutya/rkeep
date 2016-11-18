class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = 'You are not allowed to perform this action.'
    redirect_to main_app.root_url
  end

  protected

  def configure_permitted_parameters
  end
end
