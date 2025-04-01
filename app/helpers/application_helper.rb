module ApplicationHelper
  def label_classes(color: "gray", extra_classes: "")
    "bg-#{color}-200 text-#{color}-800 text-xxs px-2.5 py-0.5 rounded-sm inline-flex items-center justify-center #{extra_classes}"
  end

  def render_server_status_label
    status = Utilities::StatusChecker.read_status_from_file

    color_class = case status
    when :up
      "bg-green-500"
    when :maintenance
      "bg-amber-500"
    when :error
      "bg-red-500"
    else
      "bg-gray-500"
    end

    content_tag(:div, class: "flex items-center flex-col gap-1 cursor-help", data: { tooltip_target: "server-status-tooltip", tooltip_trigger: "hover" }) do
      content = content_tag(
        :div, nil, id: "server-status-label",
        class: "flex items-center justify-center h-[10px] w-[10px] #{color_class} text-white rounded-full transition-colors duration-800 animate-pulse"
      )

      content += content_tag(
        :div, id: "server-status-tooltip", role: "tooltip",
        class: "absolute z-10 text-xxs invisible inline-block px-3 py-2 text-sm font-medium text-white transition-opacity duration-300 #{color_class} rounded-lg shadow-xs opacity-0 tooltip"
      ) do
        status.to_s.upcase
      end

      content += content_tag(:span, nil, class: "text-xxs text-gray-500") do
        "Server status"
      end
    end
  end

  def rarity_color(rarity)
    case rarity
    when 1
      "gray"
    when 2
      "blue"
    when 3
      "yellow"
    when 4
      "pink"
    when 5
      "purple"
    end
  end

  def rariry_text(rarity)
    case rarity
    when 1
      "Common"
    when 2
      "Rare"
    when 3
      "Epic"
    when 4
      "Legendary"
    when 5
      "Mythical"
    end
  end

  def rarity_label(rarity)
    content_tag(:span, rariry_text(rarity), class: label_classes(color: rarity_color(rarity)))
  end

  def highcharts_formatted_nft_data(statistics)
    statistics.map do |stat|
      {
        amount: stat.data["amount"],
        floor_price: stat.data["floor_price"],
        date: stat.created_at.to_time.to_i * 1000
      }
    end.to_json
  end

  def nav_item_classes(path)
    request.path.include?(path) ?
      "text-gray-300 bg-gray-700 text-white" :
      "text-gray-300 hover:text-gray-600 hover:font-bold"
  end
end
