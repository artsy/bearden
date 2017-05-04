class OrganizationType < ApplicationRecord
  belongs_to :organization
  belongs_to :type

  include Auditable
  include Rankable

  delegate :name, to: :type

  def content=(value)
    type = Type.find_by name: value
    self.type = type
  end
end
