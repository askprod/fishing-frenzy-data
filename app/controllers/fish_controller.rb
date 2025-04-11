class FishController < ApplicationController
  before_action :set_collection
  before_action :set_fish_variables, only: :show

  def index
  end

  def show
  end

  private

  def set_collection
    @collection = Collection.find_by(name: "Fish")
    @fishes = @collection.fish_items.active.merge(Items::Fish.display_order)
  end

  def set_fish_variables
    @fish = @fishes.find_by(slug: params[:fish_slug]) if params[:fish_slug]
    @statistics = @fish.statistics
  end
end
