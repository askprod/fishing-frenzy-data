class Utilities::LevelFromXpCalculator
  DIVISOR = 5.0
  LEVEL_MULTIPLIER = 50.0
  PREV_LEVEL_MULTIPLIER = 0.035

  attr_reader :requested_xp, :data, :current_level, :next_level

  def initialize(requested_xp)
    @requested_xp = requested_xp.to_f
    @data = {
      1 => { level: 1, required_xp: 1000, increment: 0 },
      2 => { level: 2, required_xp: 2000, increment: 1000 },
      3 => { level: 3, required_xp: 3000, increment: 1000 },
      4 => { level: 4, required_xp: 4000, increment: 1000 },
      5 => { level: 5, required_xp: 5000, increment: 1000 },
      6 => { level: 6, required_xp: 6500, increment: 1500 },
      7 => { level: 7, required_xp: 8000, increment: 1500 },
      8 => { level: 8, required_xp: 9500, increment: 1500 },
      9 => { level: 9, required_xp: 11000, increment: 1500 },
      10 => { level: 10, required_xp: 12500, increment: 1500 }
      # Start using formula here
      # 11 => { level: 11, required_xp: 14600, increment: 2100 },
      # 12 => { level: 12, required_xp: 16900, increment: 2300 },
      # 13 => { level: 13, required_xp: 19450, increment: ... }
    }

    calculate_levels
    @current_level = @data[@data.keys.last(2).first]
    @next_level = @data[@data.keys.last]
  end

  def calculate_levels
    level = @data.size + 1
    previous_level = level - 1

    while @data[previous_level][:required_xp] <= @requested_xp
      rounddown = Utilities::Calculations.rounddown(level / DIVISOR, 0) + 1
      mround = Utilities::Calculations.mround(@data[previous_level][:required_xp] * PREV_LEVEL_MULTIPLIER, LEVEL_MULTIPLIER)
      increment = rounddown * level * LEVEL_MULTIPLIER + mround
      new_xp = (@data[previous_level][:required_xp] + increment).to_i

      @data[level] = {
        level: level,
        increment: increment.to_i,
        required_xp: new_xp
      }

      previous_level = level
      level += 1
    end
  end
end
