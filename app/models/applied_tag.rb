class AppliedTag < ApplicationRecord
  belongs_to :tag
  belongs_to :import
end
