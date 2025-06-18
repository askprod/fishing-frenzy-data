class Apis::Skymavis::Collection
  attr_reader :token_address, :criterias, :query

  def initialize(**args)
    @token_address = args[:token_address]
    @query = File.read(Rails.root.join("lib", "skymavis_graphql_queries", "collection_query.graphql"))
  end

  def self.call(**args)
    _self = self.new(**args)
    _self.call
  end

  def call
    Apis::Skymavis::Marketplace.call(operation_name, @query, variables)
  end

  def operation_name
    "GetTokenData"
  end

  def variables
    { tokenAddress: @token_address }
  end
end
