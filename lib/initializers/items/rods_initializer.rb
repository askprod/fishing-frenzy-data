class Initializers::Items::RodsInitializer
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
    [].tap do |rods_data|
      rod_ids.each do |rod_id|
        rods_data << Apis::FishingFrenzy.call("rod", path_params: { rodId: rod_id })
      end
    end
  end

  def create_records
    collection = Collection.find_by(name: "Rod")
    adapter = Adapters::FishingFrenzy::Items::Rods.call(@data)

    adapter.parsed_data.each do |rod_id, rod_data|
      if collection.rod_items.exists?(api_id: rod_id)
        collection.rod_items.find_by(api_id: rod_id).update_columns(rod_data.except(:api_id))
      else
        collection.rod_items.create({ api_id: rod_id }.merge(rod_data))
      end
    end
  end

  # /rods on the API returns an empty array so had to buy these by hand
  def rod_ids
    [
      "6718a85dba24bcdd294bcac3", # Basic Rod non_nft
      "6718a85dba24bcdd294bcac4", # Training Rod non_nft
      "6718a85dba24bcdd294bcac5", # Advanced Rod non_nft
      "6718a85dba24bcdd294bcac6", # Master's Rod non_nft
      "6718a85dba24bcdd294bcacb", # Founder's Rod non_nft
      "67d58999bccee2e00b399dd0", # Celestial Rod nft
      "67d578f4e65eb7cebf8f547b", # Golden Rod nft
      "67d58999bccee2e00b399dcf", # Radiant Rod nft
      "6718a85dba24bcdd294bcaca", # Mythos Rod nft
      "67d58999bccee2e00b399dce", # Gleaming Rod nft
      "6718a85dba24bcdd294bcac9", # Monument Rod nft
      "67d58999bccee2e00b399dcd", # Sparkle Rod nft
      "6718a85dba24bcdd294bcac7", # Keepsake Rod nft
      "6718a85dba24bcdd294bcac8" # Heritage Rod nft
    ]
  end
end
