class RemoveEventIdFromCookingRecipes < ActiveRecord::Migration[8.0]
  def change
    remove_column :cooking_recipes, :event_id, :integer
  end
end
