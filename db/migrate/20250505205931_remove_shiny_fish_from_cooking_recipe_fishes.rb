class RemoveShinyFishFromCookingRecipeFishes < ActiveRecord::Migration[8.0]
  def change
    remove_column :cooking_recipe_fishes, :shiny_fish, :boolean
  end
end
