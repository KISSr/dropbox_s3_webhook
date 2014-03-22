class DeltasController < ApplicationController
  def create
    queue_delta_jobs

    render nothing: true
  end

  def queue_delta_jobs
    params['delta']['users'].each do |user_id|
      DeltaJob.enqueue(user_id)
    end
  end
end
