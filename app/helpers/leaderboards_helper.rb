module LeaderboardsHelper
  def leaderboard_category_icon(category)
    case category.to_sym
    when :global
      ""
    when :general
      "/images/icons-2/icon_fishing.png"
    when :cooking
      "/images/icons/sushi_icon.png"
    when :frenzy_points
      "/images/icons-2/icon_frenzy_point.png"
    when :aquarium
      "/images/icons-2/icon_aquarium.png"
    end
  end

  def human_readable_leaderboard_category(category)
    {
      global: "FFDB Leaderboard",
      general: "Fishing",
      cooking: "Cooking",
      frenzy_points: "Frenzy Points",
      aquarium: "Aquarium"
    }[category.to_sym]
  end
end
