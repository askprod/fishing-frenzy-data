# == Schema Information
#
# Table name: players
#
#  id                            :integer          not null, primary key
#  api_id                        :string
#  slug                          :string
#  search_keywords               :string
#  last_automatic_api_refresh_at :datetime
#  last_manual_api_refresh_at    :datetime
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#

class Player < ApplicationRecord
  include PgSearch::Model

  validates :api_id, presence: true, uniqueness: true

  has_many :player_metrics, class_name: "Players::Metric", dependent: :destroy
  has_one :current_player_metric, -> { order(created_at: :desc) }, class_name: "Players::Metric"

  has_many :ranks, class_name: "Rank"
  has_many :leaderboards, through: :ranks

  has_one :latest_global_rank, -> { latest.global }, class_name: "Rank"
  has_one :latest_general_rank, -> { latest.general }, class_name: "Rank"
  has_one :latest_cooking_rank, -> { latest.cooking }, class_name: "Rank"
  has_one :latest_frenzy_points_rank, -> { latest.frenzy_points }, class_name: "Rank"

  pg_search_scope :search_by_keywords,
    against: :search_keywords, using: { tsearch: { prefix: true, any_word: true } }

  scope :refreshed_more_than_6_hours_ago, -> {
    where(
      "last_manual_api_refresh_at < :time OR last_automatic_api_refresh_at < :time",
      time: 6.hours.ago
    )
  }

  scope :order_by_latest_global_rank, lambda {
    subquery = Rank
      .select(:id).joins(:leaderboard).where("ranks.player_id = players.id")
      .where(leaderboards: { category: :global }).order(created_at: :desc)
      .limit(1).to_sql

    joins("LEFT JOIN ranks ON ranks.id = (#{subquery})")
      .order("ranks.rank ASC") # or DESC
  }

  scope :with_rank, -> { includes(:ranks).joins(:ranks).merge(Rank.latest) }
  scope :without_rank, -> { left_outer_joins(:ranks).where.not(ranks: { id: Rank.latest.select(:id) }).distinct }

  after_save :set_slug, if: -> { slug.nil? && current_player_metric.present? }
  after_save :set_search_keywords, if: -> { search_keywords.blank? && current_player_metric.present? }

  def display_name
    current_player_metric.twitter&.dig("name").presence ||
    current_player_metric.username.presence ||
    Utilities::Other.shorten_eth_address(current_player_metric.wallet_address)
  end

  def has_profile_image?
    current_player_metric.twitter&.dig("avatar").present?
  end

  def has_twitter_linked?
    current_player_metric&.twitter.present?
  end

  def has_telegram_linked?
    current_player_metric&.telegram.present?
  end

  def associated_pet
    return unless current_player_metric&.activated_pet.present?

    Items::Pet.find_by(api_id: current_player_metric.activated_pet)
  end

  def twitter_link
    return unless has_twitter_linked?

    "https://www.x.com/#{current_player_metric.twitter.dig("username")}"
  end

  def ron_wallet_link
    return unless current_player_metric&.wallet_address.present?

    "https://app.roninchain.com/address/#{current_player_metric.wallet_address}"
  end

  def level_calculator
    return unless current_player_metric&.exp.present?

    Utilities::LevelFromXpCalculator.new(current_player_metric.exp)
  end

  def next_level_from_exp
    level_calculator&.next_level
  end

  def current_level_from_exp
    level_calculator&.current_level
  end

  def last_api_refresh_type
    auto = last_automatic_api_refresh_at
    manual = last_manual_api_refresh_at

    if auto.nil? && manual.nil?
      :none
    elsif auto.nil?
      :manual
    elsif manual.nil?
      :automatic
    elsif auto < manual
      :automatic
    elsif auto > manual
      :manual
    else
      :none
    end
  end

  def last_api_refresh_at
    [ last_automatic_api_refresh_at, last_manual_api_refresh_at ].compact.max
  end

  def manual_refresh_enables_at
    last_manual_api_refresh_at + 30.minutes
  end

  def can_be_manually_refreshed?
    return true unless last_manual_api_refresh_at

    last_manual_api_refresh_at < 30.minutes.ago
  end

  def self.fetch_data(player_id)
    data = Apis::FishingFrenzy.call("user", path_params: { userId: player_id })
    Adapters::FishingFrenzy::Player.call(data)
  end

  def self.create_player(requested_id)
    player = create(api_id: requested_id)
    player.refresh_player_data
    player
  end

  def refresh_player_data(manual_refresh: false)
    adapter = self.class.fetch_data(api_id)
    player_metrics.build(api_data: adapter.data)
    self.last_manual_api_refresh_at = Time.current if manual_refresh
    self.last_automatic_api_refresh_at = Time.current if !manual_refresh
    self.slug = slug_from_data(adapter.data) if slug.nil?
    self.search_keywords = search_keywords_from_data(adapter.data) if search_keywords.blank?
    save
  end

  def self.refresh_players_data(scope = nil)
    players = scope ? send(scope) : all

    players.find_each do |player|
      player.refresh_player_data
    end
  end

  def slug_from_data(data)
    base_slug = [].tap do |arr|
      arr << data.dig(:twitter, :username)
      arr << data.dig(:username)
      arr << data.dig(:walletAddress)
      arr << api_id
    end&.compact_blank&.map(&:parameterize).first

    count = 1

    while Player.exists?(slug: base_slug)
      base_slug = "#{base_slug}-#{count}"
      count += 1
    end

    base_slug
  end

  def search_keywords_from_data(data)
    [].tap do |arr|
      arr << api_id
      arr << data.dig(:username)
      arr << data.dig(:twitter, :name)
      arr << data.dig(:twitter, :username)
      arr << data.dig(:walletAddress)
      arr << slug
    end&.compact_blank.map(&:strip).join(" ")
  end

  private

  def set_slug
    self.slug = slug_from_data(current_player_metric.api_data)
  end

  def set_search_keywords
    self.search_keywords = search_keywords_from_data(current_player_metric.api_data)
  end
end
