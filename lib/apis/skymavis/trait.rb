class Apis::Skymavis::Trait
  attr_reader :token_address, :criterias, :query

  def initialize(**args)
    @token_address = args[:token_address]
    @criterias = args[:criterias]
    @results = args[:results]
    @query = File.read(Rails.root.join("lib", "skymavis_graphql_queries", "trait_query.graphql"))
  end

  def self.call(token_address:, criterias: [], results: 1)
    _self = self.new(token_address: token_address, criterias: criterias, results: results)
    _self.call
  end

  def call
    Apis::Skymavis::Marketplace.call(operation_name, @query, variables)
  end

  def operation_name
    "GetERC721TokensList"
  end

  def variables
    {
      from: 0,
      auctionType: "Sale",
      rangeCriteria: [],
      size: @results,
      sort: "PriceAsc", # Could be passed as a parameter—for now we want the lowest price first
      criteria: @criterias,
      tokenAddress: @token_address
    }
  end
end
