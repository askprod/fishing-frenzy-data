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
    global: 4
  }, prefix: true

  scope :ongoing, -> { where("end_date > ?", Time.current) }
  scope :most_recently_refreshed, -> {
    joins(:leaderboard_refreshes)
      .order("leaderboard_refreshes.refreshed_at DESC")
      .limit(1).first
  }

  def self.refresh_leaderboards_data
    Initializers::LeaderboardsInitializer.call(should_create_records: true)
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
