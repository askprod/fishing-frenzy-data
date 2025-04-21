class Players::FetchPlayerJob < ApplicationJob
  queue_as :solid_queue

  def perform(player_api_id, session_id)
    Player.refresh_leaderboards_data
    Player.refresh_global_leaderboard_ranks
  end
end
