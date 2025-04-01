class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :slug
      t.string :type
      t.references :collection, null: false, foreign_key: true
      t.string :api_id
      t.jsonb :api_data

      t.timestamps
    end

    add_index :items, :api_id
    add_index :items, :type
  end
end
