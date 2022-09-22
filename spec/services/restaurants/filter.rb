require 'rails_helper'

RSpec.describe Restaurants::Filter do
  describe '.call' do
    subject(:service) { described_class.call(restaurants: restaurants, datetime: datetime) }
    let(:restaurant) { FactoryBot.create(:restaurant, :randomly_named) }
    let(:restaurant_closed_sunday) { FactoryBot.create(:restaurant, :closed_on_sunday) }
    let(:restaurants) { [ restaurant, restaurant_closed_sunday ] }
    let(:datetime_str) { '2022-09-04T16:20' }
    let(:datetime) { DateTime.parse(datetime_str) }

    context 'with an invalid datetime' do
      it 'raises an error' do
        expect do
          described_class.call(restaurants: restaurants, datetime: datetime_str)
        end.to raise_error(ActionController::BadRequest)
      end
    end

    context 'with no restaurants' do
      let(:empty_restaurants) { [] }
      let(:nil_restaurants) { nil }

      it 'returns an empty array' do
        expect(described_class.call(restaurants: empty_restaurants, datetime: datetime)).to be_empty
        expect(described_class.call(restaurants: nil_restaurants, datetime: datetime)).to be_empty
      end
    end

    context 'with no datetime' do
      it 'does not filter any restaurants' do
        filtered = described_class.call(restaurants: restaurants, datetime: nil)
        expect(filtered.length).to eq(2)
        expect(filtered).to contain_exactly(restaurant, restaurant_closed_sunday)
      end
    end

    context 'with a valid datetime' do
      it 'returns all restaurants open at that datetime' do
        filtered = subject
        expect(filtered.length).to eq(1)
        expect(filtered).to contain_exactly(restaurant)
      end
    end
  end
end
