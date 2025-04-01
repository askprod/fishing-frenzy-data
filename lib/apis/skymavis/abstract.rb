class Apis::Skymavis::Abstract
  HOST = "https://marketplace-graphql.skymavis.com/graphql"
  attr_reader :operation_name, :query, :variables

  def initialize(operation_name, query, variables)
    @operation_name = operation_name
    @query = query
    @variables = variables
  end

  def self.call(operation_name, query, variables)
    _self = self.new(operation_name, query, variables)
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
      operationName: @operation_name,
      variables: @variables,
      query: @query
    }
  end
end
