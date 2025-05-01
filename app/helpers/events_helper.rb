module EventsHelper
  def event_label(event)
    return "" unless event.name != "Default"
    content_tag(:span, event.name, class: label_classes(color: "teal"))
  end

  def event_status_label(event)
    content_tag(
      :span,
      event.ongoing? ? "Ongoing" : "Ended",
      class: label_classes(color: event.ongoing? ? "green" : "red")
    )
  end

  def event_attributes_label(event_attributes)
    color = case event_attributes["type"]
    when "scale"
      "fuchsia"
    end

    content_tag(:span, class: label_classes(color: color)) do
      safe_join([
        event_attributes["value"],
        image_tag("/images/items/item_#{event_attributes["type"]}.png", class: "h-[9px] mt-[-1px] ml-1")
      ])
    end
  end
end
