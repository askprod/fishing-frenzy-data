class CreateNftStatistics < ActiveRecord::Migration[8.0]
  def change
    create_table :nft_statistics do |t|
      t.string :nft_type
      t.string :trait
      t.float :floor_price, default: 0.0
      t.integer :amount, default: 0

      t.timestamps
    end
  end
end
