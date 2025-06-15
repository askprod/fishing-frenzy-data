class Initializers::Traits::ChestsTraitsInitializer
  def initialize
    @chests = Items::Chest.with_nfts
  end

  def self.call
    self.new.create_records
  end

  def create_records
    @chests.each do |chest|
      create_rarity_trait(chest)
      create_series_trait(chest)
    end
  end

  def create_rarity_trait(chest)
    return true if chest.traits.exists?(name: "Rarity")

    rarity_name = chest.name[/\b(Common|Rare|Epic|Legendary)\b/]

    return true unless rarity_name

    chest.traits.create(
      name: "Rarity",
      values: Array(rarity_name)
    )
  end

  def create_series_trait(chest)
    return true if chest.traits.exists?(name: "Series")

    series_name = chest.name[/\b(Origins|Founder)\b/]

    return true unless series_name

    chest.traits.create(
      name: "Series",
      values: Array(series_name)
    )
  end
end
