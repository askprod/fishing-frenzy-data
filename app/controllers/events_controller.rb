class EventsController < ApplicationController
  before_action :set_events
  before_action :set_event, only: :show

  def index
  end

  def show
  end

  private

  def set_events
    @events = Event.active
      .preload(:fish_items, :pet_items)
      .order(end_date: :desc)
  end

  def set_event
    @event = @events.find_by(slug: params[:event_slug]) if params[:event_slug]
  end
end
