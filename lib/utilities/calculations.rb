class Utilities::Calculations
  def self.wei_to_ron(wei_amount)
    wei_amount.to_f / 10**18
  end

  def self.percent_change(old_value, new_value)
    old_value, new_value = old_value.to_f, new_value.to_f
    (((new_value - old_value) / old_value.to_f) * 100).round(1)
  end

  def self.mround(number, multiple)
    (number.to_f / multiple).round * multiple
  end

  def self.rounddown(number, digits = 0)
    factor = 10 ** digits
    (number * factor).floor.to_f / factor
  end
end
