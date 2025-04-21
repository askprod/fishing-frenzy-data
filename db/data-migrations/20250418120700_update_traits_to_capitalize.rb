chest_traits = Collection.find_by(name: "Chest").items.map(&:traits)

chest_traits.flatten.each do |trait|
  trait.update(
    name: trait.name.capitalize,
    values: trait.values.map(&:capitalize)
  )
end

fish_traits = Collection.find_by(name: "Fish").items.map(&:traits)

fish_traits.flatten.each do |trait|
  trait.update(
    name: trait.name.capitalize,
    values: trait.values.map { |v| v.split(" ").map(&:capitalize).join(" ") }
  )
end
