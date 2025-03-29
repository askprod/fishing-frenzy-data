# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


fish_file = File.read(Rails.root.join("lib", "exports", "fish.json"))
fish_data = JSON.parse(fish_file).map(&:deep_symbolize_keys)

fish_data.each do |data|
  next if Fish.exists?(api_id: data.dig(:api_id))
  Fish.create(
    api_id: data.dig(:api_id),
    api_data: data.dig(:api_data)
  )
end

pets_file = File.read(Rails.root.join("lib", "exports", "pets.json"))
pets_data = JSON.parse(pets_file).map(&:deep_symbolize_keys)

pets_data.each do |data|
  next if Pet.exists?(api_id: data.dig(:api_id))
  Pet.create(
    api_id: data.dig(:api_id),
    api_data: data.dig(:api_data)
  )
end
