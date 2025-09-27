class AddCurrentBestPerformerToItemsItem < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :current_best_performer, :boolean
  end
end
