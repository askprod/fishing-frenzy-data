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
    rank = player.latest_general_rank
    color = ranking_tier_color(rank.tier_name)

    content_tag(:span, class: label_classes(color: color)) do
      content_tag(:span, class: "inline-flex items-center gap-0.5") do
        concat image_tag("/images/icons-2/icon_fishing.png", class: "h-[10px] object-cover mr-0.5")
        concat ordinal_superscript(rank.rank)
      end
    end
  end

  def player_cooking_rank_label(player)
    rank = player.latest_cooking_rank
    color = ranking_tier_color(rank.tier_name)

    content_tag(:span, class: label_classes(color: color), extra_classes: "inline-flex items-center gap-0.5") do
      content_tag(:span, class: "inline-flex items-center gap-0.5") do
        concat image_tag("/images/items/item_sushi.png", class: "h-[10px] object-cover scale-130 mr-0.5")
        concat ordinal_superscript(rank.rank)
      end
    end
  end

  def player_frenzy_points_rank_label(player)
    content_tag(:span, class: label_classes(color: "cyan")) do
      content_tag(:span, class: "inline-flex items-center gap-0.5") do
        concat image_tag("/images/icons-2/icon_frenzy_point.png", class: "h-[10px] object-cover mr-0.5")
        concat ordinal_superscript(player.latest_frenzy_points_rank.rank)
      end
    end
  end

  def player_aquarium_rank_label(player)
    content_tag(:span, class: label_classes(color: "pink")) do
      content_tag(:span, class: "inline-flex items-center gap-0.5") do
        concat image_tag("/images/icons-2/icon_aquarium.png", class: "h-[10px] object-cover mr-0.5")
        concat ordinal_superscript(player.latest_aquarium_rank.rank)
      end
    end
  end

  def player_no_ranking_label
    content_tag(:span, class: label_classes(color: "gray")) do
      "No ranking data"
    end
  end

  def ffdb_rank_label(rank)
    content_tag(:span, "FFDB Rank #{rank}", class: label_classes(color: "red"))
  end
end
