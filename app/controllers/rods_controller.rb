class RodsController < ApplicationController
  before_action :set_collection
  before_action :set_rod, only: :show

  def index
  end

  private

  def set_collection
    @collection = Collection.find_by(name: "Rod")
    # Exclude Founders Rod for now
    @rods = Items::Rod.where.not(name: "Founder’s Rod").merge(@collection.rod_items).display_order
  end

  def set_rod
    @rod = @rods.find_by(slug: params[:rod_slug]) if params[:rod_slug]
    @aggregated_stats = Utilities::StatisticsAggregator.call(@rod.statistics)
  end
end
