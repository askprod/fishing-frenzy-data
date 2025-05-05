class CreateCookingRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :cooking_recipes do |t|
      t.jsonb :api_data
      t.string :api_id

      t.timestamps
    end
  end
end
