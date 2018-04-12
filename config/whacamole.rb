Whacamole.configure(ENV['HEROKU_APP_NAME']) do |config|
  config.api_token = ENV['HEROKU_API_TOKEN']
end
