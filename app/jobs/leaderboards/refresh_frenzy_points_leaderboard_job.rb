class Leaderboards::RefreshFrenzyPointsLeaderboardJob < ApplicationJob
  queue_as :solid_queue

  def perform
    Leaderboard.refresh_frenzy_points_leaderboard(should_create_records: true)
  end
end
