# == Schema Information
#
# Table name: players_metrics
#
#  id         :integer          not null, primary key
#  api_data   :jsonb
#  player_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_players_metrics_on_player_id  (player_id)
#

class Players::Metric < ApplicationRecord
  include ApiDataAccessible

  belongs_to :player
end
