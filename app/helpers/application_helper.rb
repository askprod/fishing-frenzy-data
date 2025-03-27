module ApplicationHelper
  def label_classes(color: "gray")
    "bg-#{color}-200 text-#{color}-800 text-xs font-medium px-2.5 py-0.5 rounded-sm inline-flex items-center justify-center"
  end

  def render_server_status_label
    color_class = case Utilities::StatusChecker.read_status_from_file
    when :up
      "bg-green-500"
    when :maintenance, :error
      "bg-violet-500"
    else
      "bg-gray-500"
    end

    content_tag(:span, nil, id: "server-status-label", class: "flex items-center justify-center h-[10px] w-[10px] #{color_class} text-white rounded-full transition-colors duration-800 animate-pulse")
  end

  def rarity_label(rarity)
    label, color = case rarity.to_i
    when 1
      [ "Common", "gray" ]
    when 2
      [ "Rare", "blue" ]
    when 3
      [ "Epic", "yellow" ]
    when 4
      [ "Legendary", "pink" ]
    when 5
      [ "Mythical", "purple" ]
    end

    content_tag(:span, label, class: label_classes(color: color))
  end
end
