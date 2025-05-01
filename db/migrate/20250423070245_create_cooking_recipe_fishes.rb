class CreateCookingRecipeFishes < ActiveRecord::Migration[8.0]
  def change
    create_table :cooking_recipe_fishes do |t|
      t.references :cooking_recipe, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.float :fish_quantity
      t.boolean :shiny_fish

      t.timestamps
    end
  end
end
