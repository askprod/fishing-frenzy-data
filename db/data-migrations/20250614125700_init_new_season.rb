Initializers::Items::FishInitializer.call(should_create_records: true)
Initializers::Items::PetsInitializer.call(should_create_records: true)
Initializers::EventsInitializer.call(should_create_records: true)
Initializers::Traits::FishTraitsInitializer.call
Event.find_by(slug: "bloom-lagoon").update(active: true) # TODO: Add active in initializer ?
Cooking::Recipe.update_all(available: false)
Initializers::CookingModelsInitializer.call(should_create_records: true)
