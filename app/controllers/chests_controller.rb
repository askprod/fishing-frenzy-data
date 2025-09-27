class ChestsController < ApplicationController
  before_action :set_collection
  before_action :set_chest_variables, only: :show

  def index
  end

  def show
  end

  private

  def set_collection
    @collection = Collection.preload(:statistics).find_by(name: "Chest")
    @all_chests = @collection.chest_items
    @chests = @collection.chest_items.merge(Items::Chest.display_order)
  end

  def set_chest_variables
    @chest = @chests.find_by(slug: params[:chest_slug]) if params[:chest_slug]
    @statistics = @chest.statistics
  end
end
