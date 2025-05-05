# == Schema Information
#
# Table name: tokens
#
#  id         :integer          not null, primary key
#  key        :string
#  value      :string
#  expires_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Token < ApplicationRecord
  validates_uniqueness_of :key

  def self.get(key)
    find_by(key: key)&.value
  end

  def self.set(key, value, expires_at)
    setting = find_or_create_by(key: key)
    setting.update(
      key: key,
      value: value,
      expires_at: expires_at
    )
  end
end
