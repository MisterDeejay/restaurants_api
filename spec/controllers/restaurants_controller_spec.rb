require 'rails_helper'

RSpec.describe RestaurantsController, type: :controller do

  describe "GET #index" do
    let(:restaurant) { FactoryBot.create(:restaurant, :randomly_named) }
    let(:restaurant_closed_sunday) { FactoryBot.create(:restaurant, :closed_on_sunday) }
    let!(:restaurants) { [ restaurant, restaurant_closed_sunday ] }

    it "returns all restaurants" do
      get :index
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('application/json; charset=utf-8')

      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(json[:restaurants].length).to eq(2)
      expect(json[:restaurants].map{ |r| r[:name] }).to match_array(restaurants.map(&:name))
    end

    context "with valid datetime query params" do
      let(:query_params) { { datetime: '2022-09-04T16:20' } }

      it "returns all restaurants open at that datetime" do
        get :index, params: query_params.merge(format: :json)
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:restaurants].length).to eq(1)
        expect(json[:restaurants].map{ |r| r[:name] }).to contain_exactly(restaurant.name)

        datetime = DateTime.parse(query_params[:datetime])
        expect(restaurant.open?(datetime)).to be_truthy
        expect(restaurant_closed_sunday.open?(datetime)).to be_falsey
      end
    end

    context 'with invalid datetime query params' do
      let(:query_params) { { datetime: 'abc' } }

      it "returns a bad request error" do
        get :index, params: query_params.merge(format: :json)
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        json = JSON.parse(response.body, symbolize_names: true)
        expect(json[:errors]).to contain_exactly({ detail: 'Bad request: datetime must be a valid date' })
      end
    end
  end
end
