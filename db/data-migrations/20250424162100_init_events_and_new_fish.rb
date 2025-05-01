Event.destroy_all
Items::Fish.destroy_all
Cooking::Recipe.destroy_all

Initializers::Items::FishInitializer.call(should_create_records: true)
Initializers::Items::PetsInitializer.call(should_create_records: true)
Initializers::FishTraitsInitializer.call
Initializers::EventsInitializer.call(should_create_records: true)
Initializers::CookingModelsInitializer.call(should_create_records: true)
