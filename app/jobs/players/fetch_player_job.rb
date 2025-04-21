class Players::FetchPlayerJob < ApplicationJob
  queue_as :solid_queue

  def perform(player_api_id, session_id)
    Player.create_player(player_api_id)

    player = Player.find_by(api_id: player_api_id)

    ActionCable.server.broadcast("flashes_channel:#{session_id}", {
      type: :success,
      message: "New player added with success — welcome #{player.display_name} !"
    })
  rescue
    ActionCable.server.broadcast("flashes_channel:#{session_id}", {
      type: :error,
      message: "Error adding player #{player_api_id}"
    })
  end
end
