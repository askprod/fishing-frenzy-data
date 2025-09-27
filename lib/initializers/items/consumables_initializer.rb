class Initializers::Items::ConsumablesInitializer
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
    Apis::FishingFrenzy.call("items")
  end

  def create_records
    collection = Collection.find_by(name: "Consumables")
    adapter = Adapters::FishingFrenzy::Items::Consumables.call(@data)

    adapter.parsed_data.each do |consumable_id, consumable_data|
      if collection.consumable_items.exists?(api_id: consumable_id)
        collection.consumable_items
          .find_by(api_id: consumable_id)
          .update_columns(consumable_data.except(:api_id))
      else
        collection.consumable_items
          .create({ api_id: consumable_id }
          .merge(consumable_data))
      end
    end
  end
end
