Cooking::Recipe.where(slug: [
  "concealed-blade", "demonic-broth", "fried-flat-cat",
  "muted-horn", "crimson-snapper", "special-concealed-blade",
  "special-demonic-broth", "special-fried-flat-cat", "special-muted-horn",
  "special-silver-sakura", "special-spiritual-salad", "special-white-glade",
  "special-yin-yang-deluxe", "spiritual-salad", "white-glade",
  "yin-yang-deluxe"
]).update_all(event_id: 2)

Cooking::Recipe.update_all(available: false)
Initializers::CookingModelsInitializer.call(should_create_records: true)