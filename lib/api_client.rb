class ApiClient
  API_VERSION = :v1
  HOST = API_ROUTES.dig(API_VERSION, :host)
  ROUTES = API_ROUTES.dig(API_VERSION, :routes)

  attr_reader :route_keys, :route_data, :request_type, :route_path, :route_params

  def initialize(*route_keys)
    @route_keys = *route_keys
    @route_data = ROUTES.dig(*route_keys)
    @request_type = @route_data.dig(:type)
    @route_path = @route_data.dig(:path)
    @route_params = @route_data.dig(:params)&.split(",")&.map(&:to_sym)
  end

  def self.call(*route_keys)
    klass = self.new(*route_keys)
    klass.execute
  end

  def execute
    response = RestClient::Request.execute(
      method: @request_type.to_sym,
      url: request_full_path,
      payload: payload,
      headers: headers
    )

    JSON.parse(response)
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
    "#{HOST}/#{@route_path}"
  end

  def request_payload
    payload
  end

  private

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

  # TODO: Temp for now - find better solution for this
  def payload_mapping
    {
      accessToken: Rails.application.credentials.api.bearer
    }
  end
end
