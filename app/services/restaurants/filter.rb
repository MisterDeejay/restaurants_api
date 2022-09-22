module Restaurants
  class Filter
    def self.call(restaurants: nil, datetime: nil)
      return restaurants if datetime.nil?
      raise ActionController::BadRequest, 'datetime must be a valid date' unless datetime.is_a?(DateTime)
      return [] if restaurants.nil? || restaurants.empty?

      new(restaurants: restaurants, datetime: datetime).call
    end

    def initialize(restaurants:, datetime:)
      @restaurants = restaurants
      @datetime = datetime
    end

    def call
      @restaurants.select { |r| r.open?(@datetime) }
    end
  end
end
