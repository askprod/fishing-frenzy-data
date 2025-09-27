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
#  reference_date     :datetime
#
# Indexes
#
#  index_statistics_on_statisticable  (statisticable_type,statisticable_id)
#

class Statistic < ApplicationRecord
  belongs_to :statisticable, polymorphic: true
  scope :latest_statistics, -> { order(reference_date: :asc) }

  before_validation :define_default_attributes

  private

  def define_default_attributes
    self.reference_date = created_at if reference_date.nil?
  end
end
