Statistic.find_each do |stat|
  stat.update(
    reference_date: stat.created_at
  )
end
