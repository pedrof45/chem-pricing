module ApplicationHelper
  def login_flash_messages
    flash_messages.reject do |_key, value|
      value == "You need to sign in or sign up before continuing."
    end
  end
end
