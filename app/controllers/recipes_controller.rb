class RecipesController < ApplicationController
  before_action :set_recipes
  before_action :set_recipe, only: :show

  helper_method :filters_params,
                :safe_availability_filter,
                :safe_event_filter,
                :safe_special_filter

  def index
  end

  def show
  end

  ## FILTERS

  def filters_params
    params.fetch(:filters, {}).permit(:available, :event, :special)
  end

  def safe_availability_filter
    filters_params[:available].in?(%w[all available]) ? filters_params[:available] : "available"
  end

  def safe_event_filter
    filters_params[:event].in?(%w[all ronin_reef]) ? filters_params[:event] : "all"
  end

  def safe_special_filter
    filters_params[:special].in?(%w[all 1 0]) ? filters_params[:special] : "all"
  end

  private

  def set_recipes
    @all_recipes = Cooking::Recipe.all
    @available_recipes = @all_recipes.available

    @display_recipes = apply_filters
    @display_recipes = @display_recipes.display_order
  end

  def set_recipe
    @recipe = @recipes.find_by(slug: params[:recipe_slug]) if params[:recipe_slug]
  end

  def apply_filters
    scope = @all_recipes

    case safe_availability_filter
    when "all"
      scope
    when "available"
      scope = scope.available
    end

    case safe_special_filter
    when "all"
      scope
    when "1"
      scope = scope.special
    when "0"
      scope = scope.not_special
    end

    if safe_event_filter.present?
      return scope.merge(Cooking::Recipe.without_event) if safe_event_filter.eql?("all")
      return scope unless (event = Event.find_by(slug: safe_event_filter.dasherize)).present?

      scope = scope.merge(event.recipes)
    end

    scope
  end
end
