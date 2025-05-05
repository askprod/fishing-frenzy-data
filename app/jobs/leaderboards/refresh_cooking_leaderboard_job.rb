class Leaderboards::RefreshCookingLeaderboardJob < ApplicationJob
  queue_as :solid_queue

  def perform
    Leaderboard.refresh_cooking_leaderboard(should_create_records: true)
  end
end
