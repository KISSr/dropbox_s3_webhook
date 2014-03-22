DropboxS3Webhook::Application.routes.draw do
  get '/', controller: :verifications, action: :show
  post '/', controller: :deltas, action: :create
end
