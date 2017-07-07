class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception

  def set_user_request_format
    return unless current_user
    current_user.request_format = request.format.to_sym
  end
end
