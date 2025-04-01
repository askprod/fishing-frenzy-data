class CreateTraits < ActiveRecord::Migration[8.0]
  def change
    create_table :traits do |t|
      t.references :item, null: false, foreign_key: true
      t.string :name
      t.string :values, array: true, default: []

      t.timestamps
    end
  end
end
