class Adapters::FishingFrenzy::Recipes < Adapters::FishingFrenzy::Abstract
  private

  def parse_data
    new_data = {}
    new_data[:recipes] = {}
    new_data[:sushis] = {}

    @data.dig(:recipes).each do |recipe_data|
      recipe_id = recipe_data.dig(:id)
      new_data[:recipes][recipe_id] = recipe_data.except(:rewards, :components, :id)
      new_data[:recipes][recipe_id][:fish] = {}
      new_data[:recipes][recipe_id][:sushis] = {}

      recipe_data.dig(:components).each do |fish|
        fish_id = fish[:id]
        fish_quantity = fish[:quantity]
        shiny = fish[:isShinyFish]

        new_data[:recipes][recipe_id][:fish][fish_id] = {
          quantity: fish_quantity,
          shiny: shiny
        }
      end

      recipe_data.dig(:rewards).each do |sushi|
        sushi_name = sushi.dig(:name)
        drop_chance = sushi.dig(:dropRate)
        new_data[:recipes][recipe_id][:sushis][sushi_name] = {
          drop_chance: drop_chance
        } if drop_chance > 0

        unless new_data[:sushis].has_key? sushi_name
          new_data[:sushis][sushi_name] = sushi.except(:quantity, :dropRate)
        end
      end
    end

    new_data
  end
end
