class CreateCookingSushis < ActiveRecord::Migration[8.0]
  def change
    create_table :cooking_sushis do |t|
      t.string :name
      t.jsonb :api_data

      t.timestamps
    end
  end
end
