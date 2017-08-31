module Bearden
  class API < Grape::API
    version 'v1', using: :path
    mount Organizations::API
  end
end
