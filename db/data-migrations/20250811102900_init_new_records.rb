Cooking::Recipe.update_all(available: false)
Initializers::CookingModelsInitializer.call(should_create_records: true)

# Leaderboard.refresh_aquarium_leaderboard(should_create_records: true)
Initializers::Items::FishInitializer.call(should_create_records: true)
Initializers::Items::PetsInitializer.call(should_create_records: true)

collection = Collection.create(
  name: "Founders Pass",
  token_address: "0x3fa1e076bd4e7f4b7469ad1646332c09b275082d"
)
collection.fetch_and_create_statistics

Collection.create(name: "Consumables")

Initializers::Items::ConsumablesInitializer.call(should_create_records: true)
Initializers::Items::ChestsInitializer.call(should_create_records: true)

# Creates loot items for chests
Initializers::Items::ChestsInitializer.call(should_create_records: true)
