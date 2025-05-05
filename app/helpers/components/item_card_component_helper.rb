module Components::ItemCardComponentHelper
  def item_card_fish_attributes(fish)
    labels = [].tap do |arr|
      arr << rarity_label(fish.quality)
      arr << fish_sell_price_label(fish.sell_price)
      arr << fish_recipes_label(fish.cooking_recipes.count) if fish.cooking_recipes.any?
      arr << event_label(fish.event)
    end

    top_right_labels = [].tap do |arr|
      arr << nft_label if fish.has_nft?
    end

    attributes = {
      image_path: asset_path("/images/items/item_#{fish.image_name}.png"),
      title: fish.name,
      labels: labels
    }

    attributes[:image_classes] = "ring-1 bg-yellow-200 ring-yellow-400" if fish.has_nft?
    attributes[:top_right_labels] = top_right_labels
    attributes[:left_footer] = fish.has_nft? ? "Floor #{fish.floor_price}" : "&nbsp;".html_safe
    attributes[:right_footer] = fish.has_nft? ? "#{fish.listed_amount} listed" : "&nbsp;".html_safe
    attributes
  end

  def item_card_pet_attributes(pet)
    labels = [].tap do |arr|
      arr << rarity_label(pet.quality)
      arr << event_label(pet.event) if pet.event
    end

    {
      image_path: asset_path("/images/items/item_#{pet.image_name}.png"),
      title: pet.name,
      labels: labels,
      scale_image: true
    }
  end

  def item_card_chest_attributes(chest)
    attributes = {
      image_path: asset_path("/images/items/item_chest_#{chest.slug.underscore}.png"),
      title: chest.name
    }

    attributes[:top_right_labels] = [ nft_label ] if chest.has_nft?
    attributes[:left_footer] = chest.has_nft? ? "Floor #{chest.floor_price}" : "&nbsp;".html_safe
    attributes[:right_footer] = chest.has_nft? ? "#{chest.listed_amount} listed" : "&nbsp;".html_safe
    attributes
  end

  def player_card_attributes(player)
    labels = [].tap do |arr|
      arr << player_fishing_rank_label(player) if player.latest_general_rank
      arr << player_cooking_rank_label(player) if player.latest_cooking_rank
      arr << player_frenzy_points_rank_label(player) if player.latest_frenzy_points_rank
    end

    labels << player_no_ranking_label if labels.empty?

    top_right_labels = [].tap do |arr|
      arr << "#{ffdb_rank_label(player.latest_global_rank.rank)}".html_safe if player.latest_global_rank
    end

    {}.tap do |hash|
      hash[:subtitle] = "@#{player.current_player_metric.twitter.dig("username")}" if player&.current_player_metric.twitter&.dig("username").present?
      hash[:image_path] = player.has_profile_image? ? player.current_player_metric.twitter.dig("avatar") : asset_path("/images/extras/head_icon.png")
      hash[:title] = player.display_name
      hash[:labels] = labels
      hash[:left_footer] = "Joined in #{Date.parse(player.current_player_metric.first_login_time).strftime("%b %Y")}"
      hash[:top_right_labels] = top_right_labels
    end
  end

  def sushi_card_attributes(sushi)
    color = rarity_color(sushi.quality)

    {}.tap do |attributes|
      attributes[:title] = sushi.name
      attributes[:image_path] = asset_path("/images/items/item_#{sushi.image_name}.png")
      attributes[:labels] = [
        rarity_label(sushi.quality)
      ]
      attributes[:image_classes] = [].tap do |arr|
        arr << "ring-1"
        arr << (color.eql?("white") ? "bg-white ring-gray-200" : "bg-#{color}-200 ring-#{color}-400")
      end.join(" ")
    end
  end

  def item_card_rod_attributes(rod)
    labels = [].tap do |arr|
      arr << rarity_label(rod.quality)
      unless rod.boost_to_exp.zero?
        arr << content_tag(:span, "+#{(rod.boost_to_exp * 100).to_i}% XP", class: label_classes(color: "blue"))
      end
    end

    {}.tap do |attributes|
      attributes[:title] = rod.name
      attributes[:image_path] = asset_path("/images/items/item_#{rod.image_name}.png")
      attributes[:labels] = labels
      attributes[:top_right_labels] = [ nft_label ] if rod.has_nft?
      attributes[:left_footer] = rod.has_nft? ? "Floor #{rod.floor_price}" : "&nbsp;".html_safe
      attributes[:right_footer] = rod.has_nft? ? "#{rod.listed_amount} listed" : "&nbsp;".html_safe
    end
  end

  def recipe_card_components(recipe)
    content_tag(:div, class: "flex justify-between w-full") do
      safe_join([
        content_tag(:span, class: "flex items-center") do
          recipe.cooking_recipe_fishes.each_with_index.map do |recipe_fish, index|
            content_tag(:div, class: "relative flex flex-col items-center #{index.positive? ? '-ml-2' : ''}", style: "z-index: #{index + 1};") do
              image_tag(
                "/images/items/item_#{recipe_fish.fish.image_name}.png",
                class: "w-14 rounded-full ring-1 #{recipe_fish.fish.has_nft? ? "bg-yellow-200 ring-yellow-400" : "bg-white ring-gray-200"}"
              ) +
              content_tag(:span, "#{recipe_fish.fish_quantity}", class: label_classes(color: "gray", extra_classes: "mt-[-8px]"))
            end
          end.join.html_safe
        end,
        content_tag(:span, class: "flex items-center") do
          recipe.cooking_recipe_sushis.each_with_index.map do |recipe_sushi, index|
            catch_percent = if Utilities::Calculations.smart_round(recipe_sushi.sushi_percent_drop_chance, precision: 1) < 1
              "<1"
            else
              Utilities::Calculations.smart_round(recipe_sushi.sushi_percent_drop_chance, precision: 1)
            end

            color = if recipe_sushi.cooking_sushi.respond_to? :quality
              rarity_color(recipe_sushi.cooking_sushi.quality)
            else
              "white"
            end

            content_tag(:div, class: "relative flex flex-col items-center #{index.positive? ? '-ml-2' : ''}", style: "z-index: #{index + 1};") do
              image_tag(
                "/images/items/item_#{recipe_sushi.cooking_sushi.image_name}.png",
                class: "w-14 rounded-full ring-1 #{color.eql?("white") ? "bg-white ring-gray-200" : "bg-#{color}-200 ring-#{color}-400"}"
              ) +
              content_tag(:span, "#{catch_percent}%", class: label_classes(color: "gray", extra_classes: "mt-[-8px]"))
            end
          end.join.html_safe
        end
      ])
    end
  end
end
