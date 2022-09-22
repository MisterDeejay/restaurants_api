class RestaurantsController < ApplicationController
  before_action :set_restaurants, only: :index

  def index
    render json: { restaurants: RestaurantBlueprint.render_as_hash(@restaurants) }, format: :json
  end

  private

  def index_params
    params.permit(:datetime)
  end

  def set_restaurants
    @restaurants = Restaurant.all
    if index_params[:datetime].present?
      datetime = DateTime.parse(index_params[:datetime])
      @restaurants = Restaurants::Filter.call(restaurants: @restaurants, datetime: datetime)
    end
  rescue Date::Error => _e
    raise ActionController::BadRequest, 'datetime must be a valid date'
  end
end
