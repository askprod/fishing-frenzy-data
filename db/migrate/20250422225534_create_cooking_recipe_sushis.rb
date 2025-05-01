class CreateCookingRecipeSushis < ActiveRecord::Migration[8.0]
  def change
    create_table :cooking_recipe_sushis do |t|
      t.references :cooking_recipe, null: false, foreign_key: true
      t.references :cooking_sushi, null: false, foreign_key: true
      t.float :sushi_dropchance

      t.timestamps
    end
  end
end
