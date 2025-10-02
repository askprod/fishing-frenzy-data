class PlayersController < ApplicationController
  include ActionView::Helpers::DateHelper

  before_action :set_players
  before_action :set_leaderboard_variables, if: -> { leaderboards_enabled? }
  before_action :set_player, only: [ :show, :refresh, :stats_grid ]
  def index
    @display_players = @players
      .by_current_xp
      .first(12)
  end

  def show
  end

  def stats_grid
    render partial: "players/partials/player_stats_grids", locals: { player: @player }
  end

  def refresh
    if @player.can_be_manually_refreshed?
      Players::RefreshPlayerJob.set(wait: 3.seconds).perform_later(
        @player.api_id,
        current_session_id,
        manual_refresh: true
      )

      ActionCable.server.broadcast("flashes_channel:#{current_session_id}", {
        type: :notice,
        message: "#{@player.display_name}'s data will be refreshed shortly"
      })

      ActionCable.server.broadcast("player_channel:#{@player.api_id}:#{current_session_id}", {
        type: :refresh_card_request,
        player_id: @player.api_id
      })
    else
      ActionCable.server.broadcast("flashes_channel:#{current_session_id}", {
        type: :notice,
        message: "Manual refresh for #{@player.display_name} will be available in #{time_ago_in_words(@player.manual_refresh_enables_at)}"
      })
    end
  end

  def search
    @display_players = (
      if params[:q].blank?
        @players.by_current_xp.first(12)
      else
        @players.search_by_keywords(params[:q]).by_current_xp.first(12)
      end
    )

    render json: {
      count: @display_players.count,
      html: render_to_string(
        partial: "players/partials/players", locals: { players: @display_players }, formats: [ :html ]
      )
    }
  end

  def random
    @players = @players.random_order.limit(12)

    render json: {
      count: @players.count,
      html: render_to_string(
        partial: "players/partials/players", locals: { players: @players }, formats: [ :html ]
      )
    }
  end

  def request_new
    @current_status = params[:status]
  end

  def request_create
    requested_id = request_player_params[:requested_id]

    if Player.exists?(api_id: requested_id)
      ActionCable.server.broadcast("flashes_channel:#{current_session_id}", {
        type: :error,
        message: "Player #{requested_id} already exists"
      })

      return
    end

    Players::FetchPlayerJob.set(wait: 3.seconds).perform_later(
      requested_id,
      current_session_id
    )

    ActionCable.server.broadcast("flashes_channel:#{current_session_id}", {
      type: :notice,
      message: "New player #{requested_id} requested — should be added soon!"
    })
  end

  private

  def set_players
    @players = Player.all
      .preload(
        :current_player_metric,
        :latest_general_rank,
        :latest_cooking_rank,
        :latest_frenzy_points_rank,
        :latest_aquarium_rank,
        latest_global_rank: :leaderboard_refresh
      )
  end

  def set_leaderboard_variables
    @global_leaderboard = Leaderboard.category_global.most_recently_refreshed
    @general_leaderboard = Leaderboard.category_general.most_recently_refreshed
    @cooking_leaderboard = Leaderboard.category_cooking.most_recently_refreshed
    @frenzy_points_leaderboard = Leaderboard.category_frenzy_points.most_recently_refreshed
    @aquarium_leaderboard = Leaderboard.category_aquarium.most_recently_refreshed
    @leaderboards = [
      @global_leaderboard, @general_leaderboard,
      @cooking_leaderboard, @frenzy_points_leaderboard,
      @aquarium_leaderboard
    ].compact
  end

  def set_player
    return unless params[:player_slug] # TODO: Handle not found requests

    @player = @players.find_by(slug: params[:player_slug]) || @players.find_by(api_id: params[:player_slug])
  end

  def request_player_params
    params.require(:player).permit(:requested_id)
  end
end
