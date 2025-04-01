class Trait < ApplicationRecord
  belongs_to :item
  has_one :collection, through: :item
end
