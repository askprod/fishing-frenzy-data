class Initializers::Items::ChestsInitializer
  attr_reader :data, :should_create_records

  def initialize(should_create_records: false)
    @data = fetch_all_data
    @should_create_records = should_create_records
  end

  def self.call(should_create_records: false)
    _self = self.new(should_create_records: should_create_records)
    _self.create_records if _self.should_create_records
  end

  def fetch_all_data
    Apis::FishingFrenzy.call("chests_list")
  end

  def create_records
    collection = Collection.find_by(name: "Chest")
    adapter = Adapters::FishingFrenzy::Items::Chests.call(@data)

    adapter.parsed_data.each do |chest_id, chest_data|
      if collection.chest_items.exists?(api_id: chest_id)
        chest_item = collection.chest_items.find_by(api_id: chest_id)
        chest_item.update_columns(chest_data.except(:api_id))
      else
        chest_item = collection.chest_items
          .create({ api_id: chest_id }
          .merge(chest_data))
      end

      next if chest_data.dig(:api_data, :lootItems).blank?

      chest_data.dig(:api_data, :lootItems).flatten.each do |loot_item|
        if loot_item[:type].eql? "gold"
          create_gold_loot(chest_item, loot_item)
        elsif loot_item[:itemId].present? && (consumable = Items::Consumable.find_by(api_id: loot_item[:itemId])).present?
          create_consumable_loot(chest_item, loot_item, consumable)
        end
      end
    end
  end

  def create_consumable_loot(chest_item, loot_item, consumable)
    return if chest_item.chest_loots.consumable.exists?(consumable: consumable)

    chest_item.chest_loots.create!(
      loot_type: :consumable,
      consumable: consumable,
      quantity: loot_item[:quantity],
      drop_chance: loot_item[:dropRate] * 100
    )
  end

  def create_gold_loot(chest_item, loot_item)
    # TODO: Create Currency Models
    return if chest_item.chest_loots.gold.exists?(
      quantity: loot_item[:quantity],
      drop_chance: loot_item[:dropRate] * 100
    )

    chest_item.chest_loots.create!(
      loot_type: :gold,
      quantity: loot_item[:quantity],
      drop_chance: loot_item[:dropRate] * 100
    )
  end
end
