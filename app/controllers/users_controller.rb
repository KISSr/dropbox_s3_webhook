class UsersController < ApplicationController
  def create
    user = User.where(dropbox_user_id: params[:id])
      .first_or_initialize

    user.token = params[:user][:token]

    user.save

    head 200
  end

  def update
    user = User.find_by(dropbox_user_id: params[:id])

    user.update(user_params)

    head 200
  end

  def user_params
    params.require(:user).permit(directories: [])
  end
end
