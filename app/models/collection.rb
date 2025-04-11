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
  has_many :chest_items, -> { where(type: "Items::Chest") }, class_name: "Item"
  has_many :fish_items, -> { where(type: "Items::Fish") }, class_name: "Item"
  has_many :pet_items, -> { where(type: "Items::Pet") }, class_name: "Item"
  has_many :rod_items, -> { where(type: "Items::Rod") }, class_name: "Item"

  # TODO: Use possible future column on Item
  scope :with_nfts, -> { where.not(token_address: [ "", nil ]) }

  def self.skymavis_adapter_class
    Adapters::Skymavis::Collections
  end

  def fetch_latest_skymavis_data
    Rails.logger.info "Querying for Collection: #{name}...".green
    Apis::Skymavis::Collection.call(token_address: token_address)
  end
end
