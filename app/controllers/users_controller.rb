class UsersController < ApplicationController
  def create
    User.create(user_params)

    head 200
  end

  def user_params
    params.require(:user).permit(:dropbox_user_id, directories: [])
  end
end
