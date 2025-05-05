class Utilities::RefreshApiTokens
  def self.call
    _self = self.new
    _self.call
  end

  def call
    response = Apis::FishingFrenzy.call("refresh_tokens")
    bearer_token = response.dig(:tokens, :access)
    refresh_token = response.dig(:tokens, :refresh)

    Token.set(:api_bearer_token, bearer_token[:token], bearer_token[:expires])
    Token.set(:api_refresh_token, refresh_token[:token], refresh_token[:expires])
  end
end
