class RecipesController < ApplicationController
  before_action :set_recipes
  before_action :set_recipe, only: :show

  def index
  end

  def show
  end

  private

  def set_recipes
    @recipes = Cooking::Recipe.all
  end

  def set_recipe
    @recipe = @recipes.find_by(slug: params[:recipe_slug]) if params[:recipe_slug]
  end
end
