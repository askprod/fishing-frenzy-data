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
      labels: [ rarity_label(pet.quality) ]
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
end
