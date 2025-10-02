class UI::BestNftCardComponent < ViewComponent::Base
  include StatisticsHelper
  include IconsHelper

  def initialize(name: "", value: "", image_path: "", stats: {}, last_update: nil)
    @name = name
    @value = value
    @image_path = image_path
    @stat = stats.sort_by { |period, change| -change }.first
    @last_update = last_update
  end
end
