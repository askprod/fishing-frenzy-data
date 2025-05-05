class Utilities::GlobalLeaderboardRanker
  def initialize(players_data)
    @players_data = players_data
  end

  def self.call(players_data)
    _self = self.new(players_data)
    _self.calculate
  end

  def calculate
    scored_players = @players_data.map do |player_id, ranks_data|
      ranks = ranks_data.pluck(:rank).compact
      participation_count = ranks.size

      next if participation_count == 0

      average_rank = ranks.sum.to_f / participation_count
      weighted_score = average_rank * (
        Leaderboard.categories.except(:global).size.to_f / participation_count
      )

      {
        id: player_id,
        score: weighted_score,
        tiers: ranks_data.pluck(:tier_name).compact
      }
    end.compact

    sorted = scored_players.sort_by do |player|
      [
        player[:score],
        player[:best_tier_index]
      ]
    end

    ranked_players = {}
    sorted.each_with_index do |player, index|
      ranked_players[player[:id]] = index + 1
    end

    ranked_players
  end
end
