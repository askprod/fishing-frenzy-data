class DashboardController < ApplicationController
  def index
    @founders_pass_collection = Collection
      .eager_load(:statistics)
      .find_by(name: "Founders Pass")

    if leaderboards_enabled?
      @rank_manager = RankImprovementAnalyzer.call
      @player_stats = {
        most_gold: Player.by_most_gold.first(3),
        cooking_rank: Player.by_cooking_level.first(3),
        fishing_points: Player.by_fishing_points.first(3)
      }
    end
  end

  def about
  end
end
