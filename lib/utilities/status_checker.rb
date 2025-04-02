class Utilities::StatusChecker
  URL = "https://fishingfrenzy.co".freeze
  CHANNEL_KEY = "status_checker_channel"
  CACHE_KEY = "server_status"

  def self.check_status(forced_status: nil)
    Rails.logger.info "Checking status for #{URL}..."
    response_code = forced_status ? forced_status : RestClient.get(URL).code
    status = code_to_status(response_code)
    update_status(status)

  rescue RestClient::ServiceUnavailable
    update_status(:maintenance)
  rescue RestClient::InternalServerError
    update_status(:error)
  end

  def self.update_status(status)
    write_status_to_cache(status)
    send_status_to_channel(status)
    log_status(status)
  end

  def self.up?
    read_status_from_cache == :up
  end

  def self.maintenance?
    read_status_from_cache == :maintenance
  end

  def self.error?
    read_status_from_cache == :error
  end

  private

  def self.log_status(status)
    Rails.logger.info "Updated status for #{URL} - #{status.to_s.upcase}."
  end

  def self.send_status_to_channel(status)
    ActionCable.server.broadcast(CHANNEL_KEY, { status: status })
  end

  def self.write_status_to_cache(status)
    Rails.cache.write(CACHE_KEY, status.to_s, expires_in: 5.minutes) # Adjust expiration as needed
  end

  def self.read_status_from_cache
    cached_status = Rails.cache.read(CACHE_KEY)
    cached_status ? cached_status.to_sym : :unknown
  end

  def self.code_to_status(code)
    case code
    when 200 then :up
    when 500 then :error
    when 503 then :maintenance
    else :unknown
    end
  end
end
