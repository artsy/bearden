class Source < ApplicationRecord
  class UnknownRankType < StandardError; end
  has_many :imports, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: true
  validates :email_rank, presence: true, uniqueness: true
  validates :location_rank, presence: true, uniqueness: true
  validates :organization_name_rank, presence: true, uniqueness: true
  validates :organization_type_rank, presence: true, uniqueness: true
  validates :phone_number_rank, presence: true, uniqueness: true
  validates :website_rank, presence: true, uniqueness: true

  def rank_for(type)
    types = {
      email_rank: email_rank,
      location_rank: location_rank,
      organization_name_rank: organization_name_rank,
      organization_type_rank: organization_type_rank,
      phone_number_rank: phone_number_rank,
      website_rank: website_rank
    }

    types[type] || raise(UnknownRankType)
  end
end
