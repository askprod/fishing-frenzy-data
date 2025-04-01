class FishController < ApplicationController
  before_action :set_collection

  def index
  end

  private

  def set_collection
    @collection = Collection.find_by(name: "Fish")
    @fish = @collection.fish_items.merge(Items::Fish.display_order)
  end
end
