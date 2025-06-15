class Initializers::Traits::RodsTraitsInitializer
  def initialize
    @rods = Items::Rod.with_nfts
  end

  def self.call
    self.new.create_records
  end

  def create_records
    @rods.each do |rod|
      next if rod.traits.exists?(name: "Name")

      rod.traits.create(
        name: "Name",
        values: Array(rod.name)
      )
    end
  end
end
