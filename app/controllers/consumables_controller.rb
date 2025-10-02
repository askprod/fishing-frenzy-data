class ConsumablesController < ApplicationController
  before_action :set_consumables
  before_action :set_consumable, only: :show

  def index
  end

  def show
  end

  private

  def set_consumable
    @consumable = Items::Consumable.find_by(slug: params[:consumable_slug]) if params[:consumable_slug]
  end

  def set_consumables
    @consumables = Items::Consumable.display_order
  end
end
