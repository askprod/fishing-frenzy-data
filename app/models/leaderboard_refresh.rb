# == Schema Information
#
# Table name: leaderboard_refreshes
#
#  id             :integer          not null, primary key
#  refreshed_at   :datetime
#  leaderboard_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_leaderboard_refreshes_on_leaderboard_id  (leaderboard_id)
#

class LeaderboardRefresh < ApplicationRecord
  belongs_to :leaderboard
  has_many :ranks
end
