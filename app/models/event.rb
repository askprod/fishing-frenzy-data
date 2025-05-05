# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  active           :boolean
#  description      :string
#  end_date         :datetime
#  api_id           :string
#  name             :string
#  default_theme_id :string
#  slug             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Event < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :fish_items, class_name: "Items::Fish"
  has_many :pet_items, class_name: "Items::Pet"

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }
  scope :ongoing, -> { where("end_date IS NULL OR end_date > ?", Time.current) }

  def is_default_event?
    name.eql? "Default"
  end

  def ongoing?
    return true if end_date.nil?
    end_date > Time.current
  end

  def ended?
    !ongoing?
  end
end
