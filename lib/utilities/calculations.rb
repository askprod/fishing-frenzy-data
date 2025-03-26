class Utilities::Calculations
  def self.wei_to_ron(wei_amount)
    wei_amount.to_f / 10**18
  end
end
