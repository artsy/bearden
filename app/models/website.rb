class Website < ApplicationRecord
  belongs_to :organization
  validates_presence_of :content
end
