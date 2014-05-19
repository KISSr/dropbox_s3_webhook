class VerificationsController < ApplicationController
  skip_before_filter :authorize

  def show
    render text: challenge
  end

  private

  def challenge
    params[:challenge]
  end
end
