class AddHasNftToItems < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :has_nft, :boolean
  end
end
