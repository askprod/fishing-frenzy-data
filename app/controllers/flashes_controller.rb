class FlashesController < ApplicationController
  def index
    type = params[:flash_type]
    message = params[:flash_message]

    if type.present? && message.present?
      flash[type.to_sym] = message
    end

    render partial: "partials/flashes"
  end
end
