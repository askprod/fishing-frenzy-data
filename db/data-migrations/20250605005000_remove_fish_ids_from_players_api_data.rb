Players::Metric.find_each do |metric|
  metric.update_columns(
    api_data: metric.api_data.except("unlockedFish")
  );nil
end;nil
