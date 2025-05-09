class PetsController < ApplicationController
  before_action :set_collection
  before_action :set_pet, only: :show

  def index
  end

  private

  def set_collection
    @collection = Collection.find_by(name: "Pet")
    @pets = @collection.pet_items.merge(Items::Pet.display_order)
  end

  def set_pet
    @pet = @pets.find_by(slug: params[:pet_slug]) if params[:pet_slug]
  end
end
