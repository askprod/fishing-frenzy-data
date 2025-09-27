class Leaderboards::RefreshAquariumLeaderboardJob < ApplicationJob
  queue_as :solid_queue

  def perform
    Leaderboard.refresh_aquarium_leaderboard(should_create_records: true)
  end
end
