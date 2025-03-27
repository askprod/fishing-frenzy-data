class StatusCheckerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "status_checker_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
