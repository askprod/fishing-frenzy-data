class Statistic < ApplicationRecord
  belongs_to :statisticable, polymorphic: true
end
