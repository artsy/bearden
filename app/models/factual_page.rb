class FactualPage < ApplicationRecord
  validates_presence_of :payload, :table, :page
end
