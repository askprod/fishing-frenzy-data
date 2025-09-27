# == Schema Information
#
# Table name: items
#
#  id                     :integer          not null, primary key
#  name                   :string
#  slug                   :string
#  type                   :string
#  collection_id          :integer          not null
#  api_id                 :string
#  api_data               :jsonb
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  has_nft                :boolean
#  event_id               :integer
#  current_best_performer :boolean
#
# Indexes
#
#  index_items_on_api_id         (api_id)
#  index_items_on_collection_id  (collection_id)
#  index_items_on_event_id       (event_id)
#  index_items_on_type           (type)
#

class Item < ApplicationRecord
  include Statisticable
  include DatabaseRefreshable
  include ApiDataAccessible

  validates :api_id, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true

  belongs_to :collection
  belongs_to :event, optional: true
  has_many :traits, dependent: :destroy

  scope :with_nfts, -> { where(has_nft: true) }
  scope :without_nfts, -> { where(has_nft: [ nil, false ]) }

  before_validation :define_default_attributes

  def self.skymavis_adapter_class
    Adapters::Skymavis::Traits
  end

  def traits_to_skymavis_criterias
    traits.map { |trait| trait.slice(:name, :values) }
  end

  def fetch_latest_skymavis_data(results: 1)
    Rails.logger.info "Querying for Item: #{name}...".green

    Apis::Skymavis::Trait.call(
      token_address: collection.token_address,
      criterias: traits_to_skymavis_criterias,
      results: results
    )
  end

  private

  def define_default_attributes
    has_nft = false if has_nft.nil?
  end
end
