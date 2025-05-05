class Leaderboard::RefreshLeaderboardsJob < ApplicationJob
  queue_as :solid_queue

  def perform
    Leaderboard.refresh_leaderboards_data
  end
end
