# README

To test app:
1. Download repo to local machine
2. Run `bundle install` to install repository gems
3. Run `rails db:create db:seed` to setup and seed database
4. Run `rails s` to start server
5. Test endpoint by sending `GET` request to `localhost:3000/restaurants`. If the seeds ran correctly this should return all restaurant names from `lib/seeds/restaurant_times.csv`
6. Try filtering restaurants by datetime by using query params
  * e.g. `GET /restaurants?datetime=2022-09-04T16:20`. This will returns all restaurants open on Sun, Sep 4, 2022 @ 4:20PM local time.
  * The format of the `datetime` query param must be parseable by `DateTime.parse`
