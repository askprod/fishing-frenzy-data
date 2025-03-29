class Utilities::StatusChecker
  URL = "https://fishingfrenzy.co".freeze
  CHANNEL_KEY = "status_checker_channel"
  STATUS_FILE_PATH = Rails.root.join("lib", "utilities", "server_status.yml")

  def self.check_status(forced_status: nil)
    Rails.logger.info "Checking status for #{URL}...".red

    response_code = forced_status ? forced_status : RestClient.get(URL).code
    status = self.code_to_status(response_code)
    write_status_to_file(status)
    channel_status(status)
    log_status(status)

  rescue RestClient::ServiceUnavailable
    write_status_to_file(:maintenance)
    channel_status(:maintenance)
    log_status(:maintenance)
  rescue RestClient::InternalServerError
    write_status_to_file(:error)
    channel_status(:error)
    log_status(:error)
  end

  def self.up?
    read_status_from_file == :up
  end

  def self.maintenance?
    read_status_from_file == :maintenance
  end

  def self.error?
    read_status_from_file == :error
  end

  private

  def self.log_status(status)
    Rails.logger.info "Updated status for #{URL} - #{status.to_s.upcase}.".red
  end

  def self.channel_status(status)
    ActionCable.server.broadcast(CHANNEL_KEY, { status: status })
  end

  def self.write_status_to_file(status)
    data = { status: status.to_s }
    File.open(STATUS_FILE_PATH, "w") do |file|
      file.write(data.to_yaml)
    end
  end

  def self.read_status_from_file
    if File.exist?(STATUS_FILE_PATH)
      data = YAML.load_file(STATUS_FILE_PATH)
      data[:status].to_sym if data && data[:status]
    else
      :unknown
    end
  end

  def self.code_to_status(code)
    case code
    when 200
      :up
    when 500
      :error
    when 503
      :maintenance
    else
      :unknown
    end
  end
end
