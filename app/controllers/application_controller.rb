class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :basic_authentication

  private
  def basic_authentication

    return unless Rails.env.production?

    if request.user_agent.starts_with?('Videoarchiv')
      return true
    end

    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.secrets.app_username && password == Rails.application.secrets.app_password
    end
  end
end
