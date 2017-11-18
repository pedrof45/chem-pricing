Rails.application.routes.draw do
  mount Sidekiq::Web => '/queue'
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
