class SushisController < ApplicationController
  before_action :set_sushis
  before_action :set_sushi, only: :show

  def index
  end

  def show
  end

  private

  def set_sushis
    @sushis = Cooking::Sushi.all
  end

  def set_sushi
    @sushi = @sushis.find_by(slug: params[:sushi_slug]) if params[:sushi_slug]
  end
end
