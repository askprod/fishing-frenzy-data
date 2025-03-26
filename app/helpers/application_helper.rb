module ApplicationHelper
  def label_classes(color: "gray")
    "bg-#{color}-200 text-#{color}-800 text-xs font-medium px-2.5 py-0.5 rounded-sm inline-flex items-center justify-center"
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
