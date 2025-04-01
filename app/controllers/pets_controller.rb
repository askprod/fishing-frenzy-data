class PetsController < ApplicationController
  before_action :set_collection

  def index
  end

  private

  def set_collection
    @collection = Collection.find_by(name: "Pet")
    @pets = @collection.pet_items.merge(Items::Pet.display_order)
  end
end
