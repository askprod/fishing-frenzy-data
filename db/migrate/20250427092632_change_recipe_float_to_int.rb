class ChangeRecipeFloatToInt < ActiveRecord::Migration[8.0]
  def change
    change_column :cooking_recipe_fishes, :fish_quantity, :integer
  end
end
