class CreateChests < ActiveRecord::Migration[8.0]
  def change
    create_table :chests do |t|
      t.string :api_id
      t.jsonb :api_data

      t.timestamps
    end
  end
end
