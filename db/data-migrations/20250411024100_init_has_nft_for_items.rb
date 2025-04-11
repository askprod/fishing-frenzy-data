Items::Chest.update_all(has_nft: true)
Items::Pet.update_all(active: false)
Items::Fish.active.update_all(has_nft: true)
