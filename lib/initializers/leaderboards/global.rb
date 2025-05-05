class Initializers::Leaderboards::Global < Initializers::Leaderboards::Abstract
  def create_records
    global_leaderboard = if (lb = Leaderboard.find_by(category: :global)).present?
      lb
    else
      Leaderboard.create(category: :global, end_date: Time.current + 10.years)
    end

    leaderboard_refresh = global_leaderboard.leaderboard_refreshes.build

    global_leaderboard_data = Utilities::GlobalLeaderboardRanker.call(
      Player.with_rank.map { |player| [ player.api_id, player.ranks.latest ] }.to_h
    )

    global_leaderboard_data.each do |player_id, player_rank|
      player = Player.find_by(api_id: player_id)
      create_rank(leaderboard_refresh, player, { rank: player_rank })
    end

    leaderboard_refresh.refreshed_at = Time.current
    leaderboard_refresh.save!
  end

  private

  def set_category
    "global"
  end
end
