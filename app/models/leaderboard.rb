# == Schema Information
#
# Table name: leaderboards
#
#  id         :integer          not null, primary key
#  end_date   :datetime
#  category   :integer
#  title      :string
#  subtitle   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Leaderboard < ApplicationRecord
  LEADERBOARDS_ENABLED = false

  has_many :ranks
  has_many :players, through: :ranks
  has_many :leaderboard_refreshes
  has_one :most_recent_refresh, -> { order(refreshed_at: :desc) }, class_name: "LeaderboardRefresh"

  validates :end_date, presence: true
  validate :one_ongoing_per_category

  enum :category, {
    general: 0,
    cooking: 1,
    frenzy_points: 2,
    global: 4,
    aquarium: 5
  }, prefix: true

  scope :ongoing, -> { where("end_date > ?", Time.current) }

  def self.refresh_general_leaderboard(should_create_records: false)
    return unless LEADERBOARDS_ENABLED

    Initializers::Leaderboards::General.call(
      should_create_records: should_create_records
    )
  end

  def self.refresh_cooking_leaderboard(should_create_records: false)
    return unless LEADERBOARDS_ENABLED

    Initializers::Leaderboards::Cooking.call(
      should_create_records: should_create_records
    )
  end

  def self.refresh_frenzy_points_leaderboard(should_create_records: false)
    return unless LEADERBOARDS_ENABLED

    Initializers::Leaderboards::FrenzyPoints.call(
      should_create_records: should_create_records
    )
  end

  def self.refresh_global_leaderboard(should_create_records: false)
    return unless LEADERBOARDS_ENABLED

    Initializers::Leaderboards::Global.call(
      should_create_records: should_create_records
    )
  end

  def self.refresh_aquarium_leaderboard(should_create_records: false)
    return unless LEADERBOARDS_ENABLED

    Initializers::Leaderboards::Aquarium.call(
      should_create_records: should_create_records
    )
  end

  def self.tiers
    Rank.all.pluck(:tier_name).uniq.compact
  end

  def last_refresh_at
    latest_refresh.refreshed_at
  end

  def display_end_date?
    end_date < (Time.current + 100.days)
  end

  def self.most_recently_refreshed
    left_joins(:leaderboard_refreshes)
      .where.not(leaderboard_refreshes: { refreshed_at: nil })
      .order(leaderboard_refreshes: { refreshed_at: :desc })
      .limit(1).first
  end

  private

  def one_ongoing_per_category
    return if end_date < Time.current

    conflicts = self.class.where(category: self.category).where("end_date > ?", Time.current)
    conflicts = conflicts.where.not(id: self.id) if persisted?

    if conflicts.exists?
      errors.add(:base, "There can only be one ongoing leaderboard per category")
    end
  end
end
