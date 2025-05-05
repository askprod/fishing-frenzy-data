class Initializers::RodsTraitsInitializer
  def initialize
    @rods = Items::Rod.with_nfts
  end

  def self.call
    self.new.create_records
  end

  def create_records
    @rods.each do |rod|
      rod.traits.create(
        name: "Name",
        values: Array(rod.name)
      )
    end
  end
end
