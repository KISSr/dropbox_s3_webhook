class VerificationsController < ApplicationController
  def show
    render text: challenge
  end

  private

  def challenge
    params[:challenge]
  end
end
