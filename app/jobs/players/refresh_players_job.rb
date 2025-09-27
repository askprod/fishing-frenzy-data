class Players::RefreshPlayersJob < ApplicationJob
  queue_as :solid_queue

  def perform(scope = :first_100_by_global_rank)
    return false unless Leaderboard::LEADERBOARDS_ENABLED

    Player.refresh_players_data(scope)
  end
end
