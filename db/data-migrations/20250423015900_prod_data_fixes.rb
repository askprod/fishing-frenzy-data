Items::Fish.where(name: [ "Blue Lobster", "Frog" ]).update_all(has_nft: false)

Items::Fish.find_by(name: "Mahi-Mahi").traits.update_all(
  values: [ "Shiny Mahi-Mahi" ]
)

Items::Chest.where(name: [ "Starter", "Participation", "Frenzy" ]).update_all(has_nft: false)
