# == Schema Information
#
# Table name: ranks
#
#  id                     :integer          not null, primary key
#  player_id              :integer
#  tier_name              :string
#  rank                   :integer
#  points                 :integer
#  multiplier             :float
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  leaderboard_refresh_id :integer
#  previous_tier          :string
#  previous_rank          :integer
#
# Indexes
#
#  index_ranks_on_leaderboard_refresh_id  (leaderboard_refresh_id)
#  index_ranks_on_player_id               (player_id)
#

class Rank < ApplicationRecord
  belongs_to :player, class_name: "Player", foreign_key: :player_id
  belongs_to :leaderboard_refresh, class_name: "LeaderboardRefresh", foreign_key: :leaderboard_refresh_id
  has_one :leaderboard, through: :leaderboard_refresh

  scope :latest_per_category, -> {
    select("DISTINCT ON (ranks.player_id, leaderboards.category) ranks.*")
      .joins(leaderboard_refresh: :leaderboard)
      .order("ranks.player_id, leaderboards.category, leaderboard_refreshes.created_at DESC, ranks.id DESC")
  }
  scope :with_previous_rank, -> { where.not(previous_rank: nil) }
  scope :latest_per_player, -> {
    select("DISTINCT ON (ranks.player_id) ranks.*")
      .joins(:leaderboard_refresh)
      .preload(:leaderboard, :leaderboard_refresh, player: [
        :current_player_metric, :latest_general_rank, :latest_cooking_rank, :latest_frenzy_points_rank, :latest_aquarium_rank
      ])
      .order("ranks.player_id, leaderboard_refreshes.created_at DESC, ranks.id DESC")
  }
  scope :global, -> {
    joins(leaderboard_refresh: :leaderboard).where(leaderboards: { category: :global })
  }
  scope :general, -> {
    joins(leaderboard_refresh: :leaderboard).where(leaderboards: { category: :general })
  }
  scope :cooking, -> {
    joins(leaderboard_refresh: :leaderboard).where(leaderboards: { category: :cooking })
  }
  scope :frenzy_points, -> {
    joins(leaderboard_refresh: :leaderboard).where(leaderboards: { category: :frenzy_points })
  }
  scope :aquarium, -> {
    joins(leaderboard_refresh: :leaderboard).where(leaderboards: { category: :aquarium })
  }
end
