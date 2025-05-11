class Initializers::CookingModelsInitializer
  attr_accessor :api_data, :parsed_data, :should_create_records

  def initialize(should_create_records: false)
    @api_data = Apis::FishingFrenzy.call("recipes")
    @parsed_data = Adapters::FishingFrenzy::Recipes.call(@api_data).parsed_data
  end

  def self.call(should_create_records: false)
    _self = self.new(should_create_records: should_create_records)
    _self.create_records if should_create_records
  end

  def create_records
    @parsed_data[:sushis].each do |sushi_name, sushi_data|
      next if Cooking::Sushi.exists?(name: sushi_name)

      Cooking::Sushi.create(
        name: sushi_name,
        api_data: sushi_data
      )
    end

    @parsed_data[:recipes].each do |recipe_id, recipe_data|
      next if Cooking::Recipe.exists?(api_id: recipe_id)

      new_recipe = Cooking::Recipe.create(
        api_id: recipe_id,
        api_data: recipe_data.except(:fish, :sushis, :available),
        available: recipe_data[:available]
      )

      recipe_data[:fish].each do |fish_id, fish_data|
        Cooking::RecipeFish.create(
          cooking_recipe: new_recipe,
          fish: Items::Fish.find_by(api_id: fish_id),
          fish_quantity: fish_data[:quantity]
        )
      end

      recipe_data[:sushis].each do |sushi_name, sushi_data|
        Cooking::RecipeSushi.create(
          cooking_recipe: new_recipe,
          cooking_sushi: Cooking::Sushi.find_by(name: sushi_name),
          sushi_dropchance: sushi_data[:drop_chance],
        )
      end
    end
  end

  def clear_records
    Cooking::RecipeFish.destroy_all
    Cooking::RecipeSushi.destroy_all
    Cooking::Recipe.destroy_all
    Cooking::Sushi.destroy_all
  end
end
