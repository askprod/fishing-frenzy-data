class Item < ApplicationRecord
  include Statisticable
  include DatabaseRefreshable
  include ApiDataAccessible

  validates :api_id, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true
  validates :name, presence: true

  belongs_to :collection
  has_many :traits

  ### TODO: Might be a boolean later—need to check once FF API is up
  # For ex. Fish might not all be NFTS—isShinyFish response from API?
  scope :with_nfts, -> { all }

  # Store in column later on—like above
  def has_nft?
    true
  end

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
end
