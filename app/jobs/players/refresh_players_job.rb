class Players::RefreshPlayersJob < ApplicationJob
  queue_as :solid_queue

  def perform(scope = :refreshed_more_than_6_hours_ago)
    Player.refresh_players_data(scope)
  end
end
