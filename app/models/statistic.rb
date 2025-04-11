# == Schema Information
#
# Table name: statistics
#
#  id                 :integer          not null, primary key
#  statisticable_type :string           not null
#  statisticable_id   :integer          not null
#  data               :jsonb
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_statistics_on_statisticable  (statisticable_type,statisticable_id)
#

class Statistic < ApplicationRecord
  belongs_to :statisticable, polymorphic: true
end
