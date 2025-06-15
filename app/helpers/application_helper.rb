module ApplicationHelper
  def ordinal_superscript(number)
    suffix = case number.to_i % 100
    when 11, 12, 13
      "th"
    else
      case number.to_i % 10
      when 1 then "st"
      when 2 then "nd"
      when 3 then "rd"
      else "th"
      end
    end

    content_tag(:span) do
      concat number.to_i
      concat content_tag(:sup, suffix)
    end
  end

  def label_classes(color: "gray", extra_classes: "", text_size: "xxs")
    "
      bg-#{color}-200 text-#{color}-800
      text-#{text_size} rounded-sm
      px-1.5 py-0.5
      inline-flex items-center justify-center whitespace-nowrap
      #{extra_classes}
    "
  end

  def server_status_label
    status = Utilities::StatusChecker.read_status_from_cache

    color_class = case status
    when :up
      "bg-green-500"
    when :unavailable
      "bg-amber-500"
    when :error
      "bg-red-500"
    else
      "bg-gray-500"
    end

    content_tag(:div, class: "flex items-center flex-col gap-1 cursor-help", data: { tooltip_target: "server-status-tooltip", tooltip_trigger: "hover", tooltip_placement: :right }) do
      dot = content_tag(
        :div, nil, id: "server-status-label",
        class: "flex items-center justify-center h-3 w-3 #{color_class} text-white rounded-full transition-colors duration-800 animate-pulse"
      )

      tooltip = content_tag(
        :div, id: "server-status-tooltip",
        class: "absolute z-20 w-28 text-xxs invisible inline-block px-3 py-3 text-sm font-medium text-white transition-opacity duration-300 #{color_class} rounded-lg shadow-xs opacity-0 tooltip"
      ) do
        content_tag(:span, "Fishing Frenzy API - ") +
        content_tag(:span, id: "status") do
          status.to_s.upcase
        end
      end

      tooltip + dot
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
    else
      "white"
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

  def nav_item_active?(paths = [])
    return request.path.eql?("/") if paths.blank?
    Array(paths).map { |path| request.path.include? path }.any?
  end

  def nav_item_classes(paths = [])
    normal_classes = "hover:bg-gray-300"
    active_classes = "bg-gray-300"
    nav_item_active?(paths) ? active_classes : normal_classes
  end

  def nft_label
    content_tag(:div, class: label_classes(color: "blue", extra_classes: "text-xxs")) do
      "NFT"
    end
  end

  def ron_price_label(text)
    content_tag(:span, class: "flex items-center gap-1") do
      concat text
      concat image_tag("/images/icons-2/icon_ronin.png", class: "w-1.5 h-2.2").html_safe
    end
  end
end
