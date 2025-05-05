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

  scope :latest, -> {
    joins(leaderboard_refresh: :leaderboard).where(leaderboard_refreshes: {
      id: LeaderboardRefresh.select("MAX(id)").where("leaderboard_id = leaderboards.id")
    })
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
end
