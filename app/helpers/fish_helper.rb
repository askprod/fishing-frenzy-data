module FishHelper
  def fish_sell_price_label(price)
    content_tag(:span, class: label_classes(color: "amber")) do
      safe_join([
        price.to_s,
        image_tag("/images/icons/gold_icon.png", class: "h-[7px] mt-[-1px] ml-1")
      ])
    end
  end

  def fish_required_level_label(level)
    content_tag(:span, "Unlocked Lvl #{level}", class: label_classes(color: "cyan"))
  end

  def fish_xp_gain_label(xp)
    content_tag(:span, class: label_classes(color: "red")) do
      safe_join([
        image_tag("/images/items/item_exp_scroll.png", class: "h-[7px] mt-[-1px] mr-1"),
        "+ #{xp} XP"
      ])
    end
  end
end
