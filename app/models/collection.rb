# == Schema Information
#
# Table name: collections
#
#  id            :integer          not null, primary key
#  name          :string
#  token_address :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Collection < ApplicationRecord
  include Statisticable

  validates :name, presence: true

  has_many :items, class_name: "Item"
  has_many :items_traits, through: :items
  has_many :chest_items, -> { where(type: "Items::Chest") }, class_name: "Item"
  has_many :fish_items, -> { where(type: "Items::Fish") }, class_name: "Item"
  has_many :pet_items, -> { where(type: "Items::Pet") }, class_name: "Item"
  has_many :rod_items, -> { where(type: "Items::Rod") }, class_name: "Item"
  has_many :consumable_items, -> { where(type: "Items::Consumable") }, class_name: "Item"

  # TODO: Use possible future column on Item
  scope :with_nfts, -> { where.not(token_address: [ "", nil ]) }

  def has_nfts?
    token_address.present?
  end

  def self.skymavis_adapter_class
    Adapters::Skymavis::Collections
  end

  def fetch_latest_skymavis_data
    return unless has_nfts?

    Rails.logger.info "Querying for Collection: #{name}...".green
    Apis::Skymavis::Collection.call(token_address: token_address)
  end
end
