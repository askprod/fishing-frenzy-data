module Nft::Statisticable
  extend ActiveSupport::Concern

  included do
    def self.fetch_latest_nft_data(criterias: [], sort_by: "PriceAsc", results: 50)
      Apis::Skymavis.call(
        token_address: self.nft_token_address,
        criterias: criterias,
        sort_by: sort_by,
        results: results
      )
    end

    def self.fetch_and_create_nft_data(trait, criterias: [], sort_by: "PriceAsc", results: 50)
      response_data = self.fetch_latest_nft_data(criterias: criterias, sort_by: sort_by, results: results)
      puts response_data
      adapted_data = Adapters::Skymavis.call(response_data).parsed_data
      self.create_nft_statistic(trait, data: adapted_data)
    end

    def self.fetch_and_create_all_traits_statistics
      self.nft_data.each do |name, data|
        self.fetch_and_create_nft_data(name, criterias: data["traits"])
      end
    end

    def self.nft_statistics(traits: [])
      traits = Array(traits)
      stats = Nft::Statistic.where(nft_type: self.name)
      stats = stats.where(trait: traits) if traits.any?
      stats
    end

    def self.create_nft_statistic(trait, data: {})
      Nft::Statistic.create({ nft_type: self.name, trait: trait }.merge(data))
    end
  end
end
