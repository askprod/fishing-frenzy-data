class RankImprovementAnalyzer
  attr_reader :results
  LEADERBOARD_TYPES = %i[global general cooking frenzy_points].freeze

  def initialize
    @results = {}
  end

  def call
    analyze_all_leaderboards
    @results
  end

  def self.call
    _self = new
    _self.call
    _self
  end

  def by_percentage_increase
    @by_percentage_increase ||= @results.transform_values do |improvements|
      improvements.sort_by { |imp| -(imp[:percentage_change] || 0) }
    end
  end

  def by_percentage_decrease
    @by_percentage_decrease ||= @results.transform_values do |improvements|
      improvements.sort_by { |imp| imp[:percentage_change] || 0 }
    end
  end

  def top_and_bottom(limit = 3)
    @results.transform_values do |improvements|
      sorted = improvements.sort_by { |imp| -(imp[:percentage_change] || 0) }
      top = sorted.first(limit)
      bottom = sorted.last(limit).reverse
      { top: top, bottom: bottom }
    end
  end

  private

  def analyze_all_leaderboards
    all_latest_ranks = Rank
      .with_previous_rank
      .latest_per_player
      .preload(:player)

    ranks_by_category = all_latest_ranks.group_by { |rank| rank.leaderboard.category }

    LEADERBOARD_TYPES.each do |leaderboard_type|
      category_ranks = ranks_by_category[leaderboard_type.to_s] || []
      @results[leaderboard_type] = analyze_ranks(category_ranks)
    end
  end

  def analyze_ranks(ranks)
    [].tap do |improvements|
      ranks.each do |rank|
        improvements << {
          player: rank.player.display_name,
          slug: rank.player.slug,
          previous_rank: rank.previous_rank,
          current_rank: rank.rank,
          rank_change: rank.previous_rank - rank.rank,
          percentage_change: calculate_percentage_change(rank.previous_rank, rank.rank),
          previous_tier: rank.previous_tier,
          current_tier: rank.tier_name
        }
      end
    end
  end

  def calculate_percentage_change(previous_rank, current_rank)
    return 0 if previous_rank.nil? || current_rank.nil? || current_rank == 0

    change = previous_rank - current_rank
    (change.to_f / current_rank.to_f) * 100
  end
end
