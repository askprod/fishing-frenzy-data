class UI::StatisticCardComponent < ViewComponent::Base
  def initialize(name: "", value: "", image_path: "", percentage_change: 0)
    @name = name
    @value = value
    @image_path = image_path
    @percentage_change = percentage_change
    @percentage_suffix = percentage_suffix
    @percentage_color = percentage_color
  end

  def percentage_suffix
    return "" if @percentage_change.zero?
    @percentage_change.positive? ? "+" : ""
  end

  def percentage_color
    return "text-green-500" if @percentage_change.positive?
    return "text-red-500" if @percentage_change.negative?
    "text-gray-300"
  end
end
