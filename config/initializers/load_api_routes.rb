API_ROUTES = YAML.load_file(Rails.root.join("config/api_routes.yml")).deep_symbolize_keys
