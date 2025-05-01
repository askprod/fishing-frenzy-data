module PlayersHelper
  def ranking_tier_color(tier)
    case tier.to_s
    when "Angler"
      "purple"
    when "Pro"
      "orange"
    when "Elite"
      "blue"
    when "Apprentice"
      "green"
    when "Deck Hands"
      "stone" # Find other
    else
      "gray"
    end
  end

  def player_fishing_rank_label(player)
    data = player.current_player_rank.api_data
    color = ranking_tier_color(data.dig("fishing", "tier"))

    content_tag(:span, class: label_classes(color: color)) do
      content_tag(:span, class: "inline-flex items-center gap-0.5") do
        concat image_tag("/images/icons-2/icon_fishing.png", class: "h-[10px] object-cover mr-0.5")
        concat ordinal_superscript(data.dig("fishing", "rank"))
      end
    end
  end

  def player_cooking_rank_label(player)
    data = player.current_player_rank.api_data
    color = ranking_tier_color(data.dig("cooking", "tier"))

    content_tag(:span, class: label_classes(color: color), extra_classes: "inline-flex items-center gap-0.5") do
      content_tag(:span, class: "inline-flex items-center gap-0.5") do
        concat image_tag("/images/items/item_sushi.png", class: "h-[10px] object-cover scale-130 mr-0.5")
        concat ordinal_superscript(data.dig("cooking", "rank"))
      end
    end
  end

  def player_frenzy_points_rank_label(player)
    content_tag(:span, class: label_classes(color: "cyan")) do
      content_tag(:span, class: "inline-flex items-center gap-0.5") do
        concat image_tag("/images/icons-2/icon_frenzy_point.png", class: "h-[10px] object-cover mr-0.5")
        concat ordinal_superscript(player.current_player_rank.api_data.dig("frenzy_points", "rank"))
      end
    end
  end

  def player_no_ranking_label
    content_tag(:span, class: label_classes(color: "gray")) do
      "No ranking data"
    end
  end

  def ffdb_rank_label(rank)
    medal = case rank
    when 1
      "gold"
    when 2
      "silver"
    when 3
      "bronze"
    end

    content_tag(:div, class: "relative") do
      if medal
        img = image_tag("/images/medal_#{medal}.png", class: "w-6 h-auto")

        img + content_tag(:div, class: "absolute inset-0 flex items-center justify-center") do
          content_tag(:span, rank, class: "text-xxs")
        end
      else
        content_tag(:span, "FFDB Rank #{rank}", class: label_classes(color: "gray"))
      end
    end
  end
end
