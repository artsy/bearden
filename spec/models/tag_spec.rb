require 'rails_helper'

RSpec.describe Tag do
  it 'has multiple applied_tags' do
    shared_tag = Fabricate :tag, name: 'Penelope'
    Fabricate :applied_tag, tag: shared_tag
    Fabricate :applied_tag, tag: shared_tag
    expect(shared_tag.applied_tags.count).to eql 2
  end
end
