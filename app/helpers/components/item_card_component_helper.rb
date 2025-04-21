module Components::ItemCardComponentHelper
  def item_card_fish_attributes(fish)
    {
      image_path: asset_path("/images/items/item_#{fish.image_name}.png"),
      title: fish.fish_name,
      left_footer: "Floor #{fish.floor_price}",
      right_footer: "#{fish.listed_amount} listed",
      labels: [
        rarity_label(fish.quality),
        fish_sell_price_label(fish.sell_price)
      ]
    }
  end

  def item_card_pet_attributes(pet)
    {
      image_path: asset_path("/images/items/item_#{pet.image_name}.png"),
      title: pet.name,
      labels: [ rarity_label(pet.quality) ],
      scale_image: true
    }
  end

  def item_card_chest_attributes(chest)
    labels = [].tap do |a|
      a << nft_label if chest.has_nft?
    end

    {
      image_path: asset_path("/images/items/item_chest_#{chest.slug.underscore}.png"),
      title: chest.name,
      left_footer: "Floor #{chest.floor_price}",
      right_footer: "#{chest.listed_amount} listed",
      labels: labels
    }
  end

  def player_card_attributes(player)
    labels = [].tap do |arr|
      arr << player_fishing_rank_label(player) if player.has_fishing_rank?
      arr << player_cooking_rank_label(player) if player.has_cooking_rank?
      arr << player_frenzy_points_rank_label(player) if player.has_frenzy_points_rank?
    end

    labels << player_no_ranking_label if labels.empty?

    {}.tap do |hash|
      hash[:subtitle] = "@#{player.current_player_metric.twitter.dig("username")}" if player&.current_player_metric.twitter&.dig("username").present?
      hash[:image_path] = player.has_profile_image? ? player.current_player_metric.twitter.dig("avatar") : asset_path("/images/extras/head_icon.png")
      hash[:title] = player.display_name
      hash[:labels] = labels
      hash[:left_footer] = "Joined in #{Date.parse(player.current_player_metric.first_login_time).strftime("%b %Y")}"
      hash[:right_footer] = "FFDB Rank #{player.current_player_rank&.global_calculated_rank}"
    end
  end
end
