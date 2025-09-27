class UI::StatisticCardComponent < ViewComponent::Base
  include StatisticsHelper

  def initialize(name: "", value: "", image_path: "", percentage_changes: {})
    @name = name
    @value = value
    @image_path = image_path
    @percentage_changes = percentage_changes
  end
end
