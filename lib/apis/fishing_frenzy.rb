class Apis::FishingFrenzy
  API_VERSION = :v1.freeze
  HOST = Rails.application.config.api_routes.dig(API_VERSION, :host).freeze
  ROUTES = Rails.application.config.api_routes.dig(API_VERSION, :routes).freeze

  attr_reader :route_keys, :route_data, :request_type, :route_path, :route_params

  def initialize(*route_keys, get_params: {})
    @route_keys = *route_keys
    @get_params = get_params
    @route_data = ROUTES.dig(*route_keys)
    @request_type = @route_data.dig(:type)&.to_sym
    @route_path = @route_data.dig(:path)
    @route_params = @route_data.dig(:params)&.split(",")&.map(&:to_sym)
  end

  def self.call(*route_keys, get_params: {})
    _self = self.new(*route_keys, get_params: get_params)
    _self.call
  end

  def call
    Rails.logger.info "### Apis::FishingFrenzy ###".yellow
    Rails.logger.info "#{request_full_path}".yellow

    api_response = RestClient::Request.execute(
      method: @request_type,
      url: request_full_path,
      payload: payload,
      headers: headers
    )

    parsed_data = ActiveSupport::JSON.decode(api_response).tap do |data|
      data.deep_symbolize_keys! if data.is_a?(Hash)
      data.map!(&:deep_symbolize_keys) if data.is_a?(Array)
    end

    parsed_data
  rescue RestClient::BadRequest => e
    Rails.logger.info "400 Bad Request".red
    Rails.logger.info "Response: #{e.response.body}".yellow
    Rails.logger.info "Request URL: #{request_full_path}".blue
    Rails.logger.info "Request Payload: #{payload.inspect}".blue
    Rails.logger.info "Headers: #{headers.inspect}".blue
    nil
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.info "HTTP Error: #{e.http_code}".red
    Rails.logger.info "Response Body: #{e.response.body}".yellow if e.response
    raise e
  end

  def request_full_path
    url = "#{HOST}/"
    url += (route_parameters? ? (@route_path % route_params_mapping) : @route_path)
    url += "?#{@get_params.to_query}" if @get_params.any?
    url
  end

  def request_payload
    payload
  end

  private

  def get_request?
    @request_type == :GET
  end

  def post_request?
    @request_type == :POST
  end

  def route_parameters?
    @route_path.match?(/%\{[^}]+\}/)
  end

  def headers
    {
      Authorization: "Bearer #{Rails.application.credentials.api.bearer}"
    }
  end

  def payload
    return @payload if defined?(@payload)

    return {} if @route_params.nil?

    @payload = payload_mapping.select { |p| @route_params.include? p }
  end

  # TODO: Temp mappings for now - find better solution for this
  def payload_mapping
    {
      accessToken: Rails.application.credentials.api.bearer
    }
  end

  def route_params_mapping
    {
      eventId: "6780f4c7a48b6c2b29d82bf6",
      themeId: "6752b7a7ef93f2489cfef709"
      # These 2 can be found in events/active route
      # TODO: Might need to create models for them later?
    }
  end
end
