class Players::RefreshPlayersJob < ApplicationJob
  queue_as :solid_queue

  def perform(scope = :first_100_by_global_rank)
    Player.refresh_players_data(scope)
  end
end
