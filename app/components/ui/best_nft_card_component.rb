class UI::BestNftCardComponent < ViewComponent::Base
  include StatisticsHelper
  include IconsHelper

  def initialize(name: "", value: "", image_path: "", percentage_change: 0)
    @name = name
    @value = value
    @image_path = image_path
    @percentage_change = percentage_change
  end
end
