class CreateChestLoots < ActiveRecord::Migration[8.0]
  def change
    create_table :chest_loots do |t|
      t.references :chest, null: false, foreign_key: { to_table: :items }
      t.references :consumable, foreign_key: { to_table: :items }
      t.integer :loot_type
      t.integer :quantity
      t.float :drop_chance

      t.timestamps
    end
  end
end
