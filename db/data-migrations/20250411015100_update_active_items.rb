Items::Chest.update_all(active: true)
Items::Pet.update_all(active: true)
Items::Fish.update_all(active: false)

Items::Fish.where(name: "Shiny Smallmouth Bass").update(name: "Smallmouth Bass")
Items::Fish.where(name: "Shiny Walleye").update(name: "Walleye")
Items::Fish.where(name: "Shiny Swordfish").update(name: "Swordfish")
Items::Fish.where(name: "Shiny Tuna").update(name: "Tuna")
Items::Fish.where(name: "Shiny Sturgeon").update(name: "Sturgeon")

active_fish_names = [
  "Anchovy", "Minnow", "Carp", "Goby", "Herring", "Bluegill", "Sardine", "Bream",
  "Red Snapper", "Smallmouth Bass", "Walleye", "Barramundi", "Perch", "Chub",
  "Rainbow Trout", "Salmon", "Swordfish", "Flounder", "Mahi-Mahi", "Pike", "Tuna",
  "Marlin", "Catfish", "Hammerhead Shark", "Sturgeon", "Blue Lobster", "Frog"
]

Items::Fish.where(name: active_fish_names).update_all(active: true)
