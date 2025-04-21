class FlashesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "flashes_channel:#{params[:session_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
