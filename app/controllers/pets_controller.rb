class PetsController < ApplicationController
  before_action :set_collection
  before_action :set_pet, only: :show

  helper_method :filters_params,
                :safe_event_filter,
                :safe_rarity_filter

  def index
  end

  ## FILTERS

  def filters_params
    params.fetch(:filters, {}).permit(:event, :rarity)
  end

  def safe_event_filter
    if filters_params[:event].in?(%w[all ronin_reef bloom_lagoon])
      filters_params[:event]
    else
      Event.ongoing.not_default.any? ? Event.ongoing.not_default.first.slug : "all"
    end
  end

  def safe_rarity_filter
    filters_params[:rarity].in?(%w[all 1 2 3 4 5]) ? filters_params[:rarity] : "all"
  end

  private

  def set_collection
    @collection = Collection.preload(:statistics).find_by(name: "Pet")
    @all_pets = @collection.pet_items

    @display_pets = apply_filters
    @display_pets = @display_pets.merge(Items::Pet.display_order)
  end

  def set_pet
    @pet = @all_pets.find_by(slug: params[:pet_slug]) if params[:pet_slug]
  end

  def apply_filters
    scope = @all_pets

    if safe_rarity_filter.present? && !safe_rarity_filter.eql?("all")
      scope = scope.merge(Items::Pet.by_rarity(safe_rarity_filter))
    end

    if safe_event_filter.present? && !safe_event_filter.eql?("all")
      return scope.merge(Items::Pet.with_event.event_ongoing) if safe_event_filter.eql?("all")
      return scope unless (event = Event.find_by(slug: safe_event_filter.dasherize)).present?

      scope = scope.merge(event.pet_items)
    end

    scope
  end
end
