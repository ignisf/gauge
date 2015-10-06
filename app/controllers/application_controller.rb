class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def current_ip_address
    # request.env['HTTP_X_FORWARDED_FOR'] ||
    request.remote_ip
  end
end
