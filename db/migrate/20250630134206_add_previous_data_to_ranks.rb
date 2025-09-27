class AddPreviousDataToRanks < ActiveRecord::Migration[8.0]
  def change
    add_column :ranks, :previous_tier, :string
    add_column :ranks, :previous_rank, :integer
  end
end
