module Nft::Configurable
  extend ActiveSupport::Concern

  included do
    def self.nft_config
      @config ||= Rails.application.config.nfts_configuration[name.downcase]
    end

    def self.nft_token_address
      self.nft_config["token_address"]
    end

    def self.nft_types
      self.nft_data.keys
    end

    def self.nft_data
      nft_config["types"]
    end
  end
end
