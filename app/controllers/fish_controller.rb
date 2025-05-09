class FishController < ApplicationController
  before_action :set_collection
  before_action :set_fish, only: :show

  helper_method :filters_params,
                :safe_event_filter,
                :safe_fish_type_filter,
                :safe_rarity_filter

  def index
  end

  def show
  end

  def filters_params
    params.fetch(:filters, {}).permit(:fish_type, :event, :rarity)
  end

  def safe_fish_type_filter
    filters_params[:fish_type].in?(%w[all shiny non_shiny]) ? filters_params[:fish_type] : "all"
  end

  def safe_event_filter
    filters_params[:event].in?(%w[all ronin_reef]) ? filters_params[:event] : "all"
  end

  def safe_rarity_filter
    filters_params[:rarity].in?(%w[all 1 2 3 4 5]) ? filters_params[:rarity] : "all"
  end

  private

  def set_collection
    @collection = Collection.find_by(name: "Fish")
    @all_fishes = @collection.items
    @active_fishes = @all_fishes.joins(:event).includes(:cooking_recipes)

    @display_fishes = apply_filters
    @display_fishes = @display_fishes.merge(Items::Fish.display_order)
  end

  def set_fish
    @fish = @all_fishes.find_by(slug: params[:fish_slug]) if params[:fish_slug]
    @aggregated_stats = Utilities::StatisticsAggregator.call(@fish.statistics)
  end

  def apply_filters
    scope = @all_fishes

    case safe_fish_type_filter
    when "shiny"
      scope = scope.with_nfts
    when "non_shiny"
      scope = scope.without_nfts
    end

    if safe_rarity_filter.present? && !safe_rarity_filter.eql?("all")
      scope = scope.merge(Items::Fish.by_rarity(safe_rarity_filter))
    end

    if safe_event_filter.present?
      return scope.merge(Items::Fish.with_event.event_ongoing) if safe_event_filter.eql?("all")
      return scope unless (event = Event.find_by(slug: safe_event_filter.dasherize)).present?

      scope = scope.merge(event.fish_items)
    end

    scope
  end
end
