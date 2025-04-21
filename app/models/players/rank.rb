# == Schema Information
#
# Table name: players_ranks
#
#  id                     :integer          not null, primary key
#  api_data               :jsonb
#  global_calculated_rank :integer
#  player_id              :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_players_ranks_on_player_id  (player_id)
#

class Players::Rank < ApplicationRecord
  include ApiDataAccessible

  belongs_to :player
end
