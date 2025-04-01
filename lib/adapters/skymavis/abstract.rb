class Adapters::Skymavis::Abstract
  attr_accessor :data, :parsed_data

  def initialize(data)
    @data = data
    @parsed_data = parse_data
    define_dynamic_methods
  end

  def self.call(data)
    self.new(data)
  end

  private

  def parse_data
    {}
  end

  def define_dynamic_methods
    @parsed_data.each do |key, value|
      self.class.define_method(key) do
        @parsed_data[key]
      end
    end
  end
end
