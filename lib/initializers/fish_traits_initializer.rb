class Initializers::FishTraitsInitializer
  def initialize
    @fish = Items::Fish.with_nfts
  end

  def self.call
    self.new.create_records
  end

  def create_records
    @fish.each do |fish|
      fish.traits.create(
        name: "Name",
        values: Array(fish.name)
      )
    end
  end
end
