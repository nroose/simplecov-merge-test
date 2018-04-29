require 'rails_helper'

RSpec.describe Test, type: :model do
  describe 'test 2' do
    it 'returns test 2' do
      expect(Test.test_2).to eq 'test 2'
    end
  end
end
