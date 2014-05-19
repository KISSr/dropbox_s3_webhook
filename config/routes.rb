require 'resque/server'

DropboxS3Webhook::Application.routes.draw do
  mount Resque::Server.new, at: '/resque'
  get '/', controller: :verifications, action: :show
  post '/', controller: :deltas, action: :create
  resources :users, only: [:create, :destroy]
end
