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

  describe '#completed?' do
    context 'with an incomplete import' do
      it 'returns false' do
        import = Fabricate :import, state: ImportMicroMachine::UNSTARTED
        expect(import).to_not be_completed
      end
    end

    context 'with a completed import' do
      it 'returns true' do
        import = Fabricate :import, state: ImportMicroMachine::FINISHED
        expect(import).to be_completed
      end
    end

    context 'with an import that is syncing' do
      it 'returns true' do
        import = Fabricate :import, state: ImportMicroMachine::SYNCING
        expect(import).to be_completed
      end
    end

    context 'with an import that has synced' do
      it 'returns true' do
        import = Fabricate :import, state: ImportMicroMachine::SYNCED
        expect(import).to be_completed
      end
    end
  end
end
