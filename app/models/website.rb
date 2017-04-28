class Website < ApplicationRecord
  belongs_to :organization

  validates :organization, presence: true
  validates(
    :content,
    format: { with: /\./ },
    length: { maximum: 256 },
    presence: true,
    uniqueness: true
  )

  include Rankable
  include Auditable
end
