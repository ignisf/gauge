class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def current_ip_address
    # request.env['HTTP_X_FORWARDED_FOR'] ||
    request.remote_ip
  end

  def sort_seed
    if session[:random_sort_seed].present?
      session[:random_sort_seed].to_i
    else
      session[:random_sort_seed] = Random.new_seed
    end
  end
end
