Rails.application.config.api_routes = YAML.load_file(Rails.root.join("config", "api_routes.yml")).deep_symbolize_keys.with_indifferent_access
