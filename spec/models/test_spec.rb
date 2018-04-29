require 'rails_helper'

RSpec.describe Test, type: :model do
  describe 'test' do
    it 'returns test' do
      expect(Test.test).to eq 'test'
    end
  end
end
