class Leaderboards::RefreshGlobalLeaderboardJob < ApplicationJob
  queue_as :solid_queue

  def perform
    Leaderboard.refresh_global_leaderboard(should_create_records: true)
  end
end
