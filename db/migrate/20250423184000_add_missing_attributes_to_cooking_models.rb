class AddMissingAttributesToCookingModels < ActiveRecord::Migration[8.0]
  def change
    add_column :cooking_recipes, :slug, :string
    add_column :cooking_sushis, :slug, :string
  end
end
