class Leaderboards::RefreshGeneralLeaderboardJob < ApplicationJob
  queue_as :solid_queue

  def perform
    Leaderboard.refresh_general_leaderboard(should_create_records: true)
  end
end
