require 'rails_helper'

describe Import do
  describe '#state' do
    context 'with an invalid state' do
      it 'is not valid' do
        import = Fabricate :import
        import.state = 'invalid'
        expect(import).to_not be_valid
        expect(import.errors.messages).to eq(
          { state: ['is not included in the list'] }
        )
      end
    end

    context 'with a valid state' do
      it 'is valid' do
        import = Fabricate :import
        import.state = ImportMicroMachine::FINISHED
        expect(import).to be_valid
      end
    end
  end
end
