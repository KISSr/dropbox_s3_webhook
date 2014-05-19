class UsersController < ApplicationController
  def create
    User.create(
      dropbox_user_id: params[:id],
      token: params[:user][:token]
    )

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
