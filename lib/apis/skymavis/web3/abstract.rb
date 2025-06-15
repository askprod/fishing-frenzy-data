class Apis::Skymavis::Web3::Abstract
  HOST = "https://api-gateway.skymavis.com/skynet/ronin/web3/v2"

  def initialize
    @path = "" # To override
  end

  def self.call(**args)
    _self = self.new(**args)
    _self.call
  end

  def call
    api_response = RestClient::Request.execute(
      method: :GET,
      url: full_url,
      headers: headers
    )

    JSON.parse(api_response.body).deep_symbolize_keys
  rescue RestClient::ExceptionWithResponse => e
    puts "Error: #{e.response}"
    raise
  end

  private

  def full_url
    "#{HOST}/#{@path}"
  end

  def headers
    {
      accept: :json,
      "X-API-KEY": Rails.application.credentials.dig(:skymavis_web3_api_key)
    }
  end
end
