class RecipesController < ApplicationController
  before_action :set_recipes
  before_action :set_recipe, only: :show

  helper_method :filters_params,
                :safe_availability_filter,
                :safe_special_filter

  def index
  end

  def show
  end

  ## FILTERS

  def filters_params
    params.fetch(:filters, {}).permit(:available, :special)
  end

  def safe_availability_filter
    filters_params[:available].in?(%w[all available]) ? filters_params[:available] : "available"
  end

  def safe_special_filter
    filters_params[:special].in?(%w[all 1 0]) ? filters_params[:special] : "all"
  end

  private

  def set_recipes
    @all_recipes = Cooking::Recipe.all.preload(
      cooking_recipe_fishes: :fish,
      cooking_recipe_sushis: :cooking_sushi
      )
    @available_recipes = @all_recipes.available

    @display_recipes = apply_filters
    @display_recipes = @display_recipes.display_order
  end

  def set_recipe
    @recipe = @all_recipes.find_by(slug: params[:recipe_slug]) if params[:recipe_slug]
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

    scope
  end
end
