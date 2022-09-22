require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  let(:restaurant) { build(:restaurant, :randomly_named) }

  describe 'validations' do
    let(:restaurant_no_name) { build(:restaurant, name: nil) }
    let(:restaurant_same_name) { build(:restaurant, name: restaurant.name) }

    it 'is valid with valid attributes' do
      expect(restaurant).to be_valid
    end
    
    it 'is not valid without a name' do
      expect(restaurant_no_name).to_not be_valid
    end

    it 'is not valid without a unique name' do
      restaurant.save
      expect(restaurant_same_name).to_not be_valid
    end
  end

  describe '#hours_as_hash' do
    it 'converts the hours string to a hash' do
      restaurant.hours.each do |day, day_hours|
        expect(restaurant.hours[day]).to be_an_instance_of(String)
        expect(restaurant.hours_as_hash[day].to_json).to eq(day_hours.gsub(', ',',').gsub('=>', ':'))
      end
    end
  end

  describe '#closes_next_day' do
    before do
      restaurant.hours['saturday'] = {'open' => '1130', 'closed' => '0200'}
      restaurant.save
      restaurant.reload
    end

    it 'returns true if the restaurant closes after midnight' do
      expect(restaurant.closes_next_day?('saturday')).to be_truthy
    end

    it 'returns false if the restaurant closes before midnight' do
      expect(restaurant.closes_next_day?('monday')).to be_falsey
    end
  end

  describe '#open?' do
    let(:hours) do
      {
        'monday' => { 'open'=>'1000', 'closed'=>'2000' },
        'tuesday' => { 'open' => nil, 'closed' => nil },
        'wednesday' => { 'open' => nil, 'closed' => nil },
        'thursday' => { 'open' => nil, 'closed' => nil },
        'friday' => { 'open' => '1000', 'closed' => '2200' },
        'saturday' => { 'open' => '1000', 'closed' => '2200' },
        'sunday' => { 'open' => '1500', 'closed' => '2000' }
      }
    end

    before do
      restaurant.hours = hours
      restaurant.save
      restaurant.reload
    end

    it 'returns true if the restaurant is open on a given datetime' do
      datetime = DateTime.parse('2022-09-04T16:20')
      expect(restaurant.open?(datetime)).to be_truthy
    end

    it 'returns false if the restaurant is not open on a given datetime' do
      datetime = DateTime.parse('2022-09-04T23:20')
      expect(restaurant.open?(datetime)).to be_falsey
    end
  end
end
