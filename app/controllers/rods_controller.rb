class RodsController < ApplicationController
  before_action :set_collection

  def index
  end

  private

  def set_collection
    @collection = Collection.find_by(name: "Rod")
    @rods = @collection.rod_items
  end
end
