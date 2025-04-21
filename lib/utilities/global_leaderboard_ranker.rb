class Utilities::GlobalLeaderboardRanker
  TOTAL_LEADERBOARDS = %w[cooking fishing frenzy_points].freeze
  TIER_ORDER = [ "Angler", "Pro", "Elite", "Apprentice", "Deck Hands" ].freeze

  def initialize(players_data)
    @players_data = players_data
  end

  def calculate
    scored_players = @players_data.map do |player_id, ranks_hash|
      ranks = leaderboard_ranks(ranks_hash)
      participation_count = ranks.size

      next if participation_count == 0

      average_rank = ranks.sum.to_f / participation_count
      weighted_score = average_rank * (TOTAL_LEADERBOARDS.size.to_f / participation_count)

      {
        id: player_id,
        score: weighted_score,
        tiers: extract_tiers(ranks_hash)
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

  private

  def leaderboard_ranks(ranks_hash)
    TOTAL_LEADERBOARDS.map { |key| ranks_hash[key]&.dig("rank") }.compact
  end

  def extract_tiers(ranks_hash)
    TOTAL_LEADERBOARDS.map { |key| ranks_hash[key]&.dig("tier") }.compact
  end
end
