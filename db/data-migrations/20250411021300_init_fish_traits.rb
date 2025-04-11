Items::Fish.active.each do |fish|
  fish.traits.create(
    name: "name",
    values: Array("shiny #{fish.name.downcase}")
  )
end
