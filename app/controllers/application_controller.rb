class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_session_id

  helper_method :current_session_id
  helper_method :leaderboards_enabled?

  def current_session_id
    session[:session_id]
  end

  def leaderboards_enabled?
    Leaderboard::LEADERBOARDS_ENABLED
  end

  private

  def set_session_id
    session[:session_id] ||= SecureRandom.hex(6)
  end
end
