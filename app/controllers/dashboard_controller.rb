class DashboardController < ApplicationController
  def index
    @founders_pass_collection = Collection
      .eager_load(:statistics)
      .find_by(name: "Founders Pass")

    if leaderboards_enabled?
      @rank_manager = RankImprovementAnalyzer.call
    end

    @best_fish_performance = StatisticsPerformanceAnalyzer
      .call(Items::Fish.with_nfts)
    @best_chest_performance = StatisticsPerformanceAnalyzer
      .call(Items::Chest.with_nfts)
    @best_rod_performance = StatisticsPerformanceAnalyzer
      .call(Items::Rod.with_nfts)

    if leaderboards_enabled?
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
