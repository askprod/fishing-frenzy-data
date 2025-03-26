class Fish::MainController < ApplicationController
  def index
    @fishes = Fish.all.non_shiny.display_order
  end
end
