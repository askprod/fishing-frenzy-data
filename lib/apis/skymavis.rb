class Apis::Skymavis
  HOST = "https://marketplace-graphql.skymavis.com/graphql"
  attr_reader :token_address, :criterias, :query

  def initialize(token_address:, criterias: [], sort_by: "PriceAsc", results: 50)
    @token_address = token_address
    @criterias = criterias
    @sort_by = sort_by
    @results = results
    @query = File.read(Rails.root.join("lib/utilities/skymavis_erc721_query.graphql"))
  end

  def self.call(token_address:, criterias: [], sort_by: "PriceAsc", results: 1)
    _self = self.new(token_address: token_address, criterias: criterias)
    _self.call
  end

  def call
    api_response = RestClient::Request.execute(
      method: :POST,
      url: HOST,
      payload: payload.to_json,
      headers: headers
    )

    JSON.parse(api_response.body).deep_symbolize_keys
  rescue RestClient::ExceptionWithResponse => e
    puts "Error: #{e.response}"
    raise
  end

  def headers
    {
      content_type: :json,
      accept: :json
    }
  end

  def payload
    {
      operationName: "GetERC721TokensList",
      variables: {
          from: 0,
          auctionType: "All",
          size: @results,
          sort: @sort_by,
          criteria: @criterias,
          rangeCriteria: [],
          tokenAddress: @token_address # "0x9c76fc5bd894e7f51c422f072675c876d5998a9e"
        },
      query: @query
    }
  end
end
