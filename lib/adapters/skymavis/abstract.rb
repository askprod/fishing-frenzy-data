class Adapters::Skymavis::Abstract
  attr_accessor :data, :parsed_data

  def initialize(data)
    @data = data
    @parsed_data = parse_data
  end

  def self.call(data)
    self.new(data)
  end

  private

  def parse_data
    {}
  end
end
