class DeltasController < ApplicationController
  def create
    queue_delta_jobs

    render nothing: true
  end

  def queue_delta_jobs
    params[:delta][:users].each do |user_id|
      Resque.enqueue(DeltaJob, user_id.to_s)
    end
  end
end
