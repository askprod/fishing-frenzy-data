class PlayerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_channel:#{params[:player_id]}:#{params[:session_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
