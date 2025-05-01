class FishController < ApplicationController
  before_action :set_collection
  before_action :set_fish, only: :show

  def index
  end

  def show
  end

  private

  def set_collection
    @collection = Collection.find_by(name: "Fish")
    @all_fishes = @collection.items

    @active_fishes = @all_fishes.joins(:event).merge(Event.active).active.merge(Items::Fish.display_order)
    @shiny_fishes = @active_fishes.with_nfts.merge(Items::Fish.display_order)
    @default_fishes = @active_fishes.without_nfts.merge(Items::Fish.display_order)

    @display_fishes = (
      case params[:fish_type]
      when "shiny"
        @shiny_fishes
      when "other"
        @default_fishes
      when "all"
        @active_fishes
      else
        @shiny_fishes
      end
    )
  end

  def set_fish
    @fish = @active_fishes.find_by(slug: params[:fish_slug]) if params[:fish_slug]
    @aggregated_stats = Utilities::StatisticsAggregator.call(@fish.statistics)
  end
end
