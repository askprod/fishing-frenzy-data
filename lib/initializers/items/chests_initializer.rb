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
    [].tap do |chest_data|
      chests_ids.each do |c_id|
        chest_data << Apis::FishingFrenzy.call("chest", path_params: { chestId: c_id })
      end
    end
  end

  def create_records
    collection = Collection.find_by(name: "Chest")
    adapter = Adapters::FishingFrenzy::Items::Chests.call(@data)

    adapter.parsed_data.each do |chest_id, chest_data|
      if collection.chest_items.exists?(api_id: chest_id)
        collection.chest_items.find_by(api_id: chest_id).update_columns(chest_data.except(:api_id))
      else
        collection.chest_items.create({ api_id: chest_id }.merge(chest_data))
      end
    end
  end

  def chests_ids
    [
      "66cc4394419b5b2e6c67b3bc", # Legendary Founder Chest nft
      "67d5899abccee2e00b399dec", # Legendary Origins Chest nft
      "66cc4374419b5b2e6c67b3b4", # Epic Founder Chest nft
      "67d5899abccee2e00b399ded", # Epic Origins Chest nft
      "67d5899abccee2e00b399dee", # Rare Origins Chest nft
      "67d5899abccee2e00b399def", # Common Origins Chest nft
      "66cc43a9419b5b2e6c67b3c0", # Rare Founder Chest nft
      "66cc4383419b5b2e6c67b3b8", # Common Founder Chest nft
      "66da652977fbb86eacd09fb4", # Participation Chest non_nft
      "67d5899abccee2e00b399df0" # Starter Chest non_nft
    ]
  end
end
