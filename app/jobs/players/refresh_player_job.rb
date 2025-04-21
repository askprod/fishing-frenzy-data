class Players::RefreshPlayerJob < ApplicationJob
  queue_as :solid_queue

  def perform(player_api_id, session_id, manual_refresh: false)
    player = Player.find_by(api_id: player_api_id)
    player.refresh_player_data(manual_refresh: manual_refresh)

    ActionCable.server.broadcast("flashes_channel:#{session_id}", {
      type: :success,
      message: "Player #{player.display_name}'s data refreshed!"
    })

    ActionCable.server.broadcast("player_channel:#{player.api_id}:#{session_id}", {
      type: :refresh_card_success
    })
  rescue
    ActionCable.server.broadcast("flashes_channel:#{session_id}", {
      type: :error,
      message: "Error refreshing player #{player.display_name}"
    })

    ActionCable.server.broadcast("player_channel:#{player.api_id}:#{session_id}", {
      type: :refresh_failed
    })
  end
end
