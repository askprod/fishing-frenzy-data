class Pets::MainController < ApplicationController
  def index
    @pets = Pet.all.display_order
  end
end
