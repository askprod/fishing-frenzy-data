# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

[
  [ "Pet", "" ],
  [ "Fish", "" ],
  [ "Rod", "0x77ce5148b7ad284e431175ad7258b54a64816da6" ],
  [ "Chest", "0x9c76fc5bd894e7f51c422f072675c876d5998a9e" ]
].each do |name, address|
  Collection.create(
    name: name,
    token_address: address,
  ) unless Collection.exists?(name: name)
end

fish_file = File.read(Rails.root.join("lib", "exports", "fish.json"))
fish_data = JSON.parse(fish_file).map(&:deep_symbolize_keys)
fish_collection = Collection.find_by(name: "Fish")

fish_data.each do |data|
  next if fish_collection.items.exists?(api_id: data[:api_id])
  fish_collection.items.create(
    type: "Items::Fish",
    name: data.dig(:api_data, :fishName),
    slug: data.dig(:api_data, :imageName).dasherize,
    api_id: data.dig(:api_id),
    api_data: data.dig(:api_data)
  )
end

pets_file = File.read(Rails.root.join("lib", "exports", "pets.json"))
pets_data = JSON.parse(pets_file).map(&:deep_symbolize_keys)
pets_collection = Collection.find_by(name: "Pet")

pets_data.each do |data|
  next if pets_collection.items.exists?(api_id: data.dig(:api_id))
  pets_collection.items.create(
    type: "Items::Pet",
    name: data.dig(:api_data, :name),
    slug: data.dig(:api_data, :imageName).dasherize,
    api_id: data.dig(:api_id),
    api_data: data.dig(:api_data)
  )
end

# Chests - Temp for now since API is not available
chests_collection = Collection.find_by(name: "Chest")
chest_config = Rails.application.config.nfts_configuration.dig("chest")
chest_types = (chest_config["types"].keys + [ "frenzy", "participation", "starter" ])

chest_types.each do |type|
  chests_collection.items.create(
    type: "Items::Chest",
    name: type.split('_').map(&:capitalize).join(' '),
    slug: type.dasherize,
    api_id: SecureRandom.hex(12),
    api_data: {},
  ) unless chests_collection.items.exists?(slug: type.dasherize)

  item = chests_collection.items.find_by(slug: type.dasherize)
  chest_traits = chest_config.dig("types", type, "traits")
  next unless chest_traits

  chest_traits.each do |trait|
    item.traits.create!(
      name: trait["name"],
      values: trait["values"]
    ) unless item.traits.exists?(name: trait["name"])
  end
end
