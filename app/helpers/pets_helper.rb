module PetsHelper
  def pet_price_label(price_data)
    unit, amount = price_data.dig("unit"), price_data.dig("amount")

    image_path, color = case unit
    when "Scale"
      [ "/images/items/item_scale.png", "fuchsia" ]
    end

    content_tag(:span, class: label_classes(color: color)) do
      safe_join([
        amount.to_s,
        image_tag(image_path, class: "h-[9px] mt-[-1px] ml-1")
      ])
    end
  end
end
