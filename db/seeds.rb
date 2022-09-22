# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'csv'

def set_hours(days_range, hours_set, restaurant_hours)
  days_hash = {
    'Mon' => 'monday',
    'Tue' => 'tuesday',
    'Wed' => 'wednesday',
    'Thu' => 'thursday',
    'Fri' => 'friday',
    'Sat' => 'saturday',
    'Sun' => 'sunday'
  }
  if days_range.length > 1
    starting_day = days_hash[days_range[0]]
    starting_day_idx = days_hash.values.index(starting_day)
    ending_day = days_hash[days_range[1]]
    ending_day_idx = days_hash.values.index(ending_day)
    days_hash.values[starting_day_idx..ending_day_idx].each do |day|
      split_and_set(restaurant_hours, hours_set, day)
    end
  else
    day = days_hash[days_range[0]]
    split_and_set(restaurant_hours, hours_set, day)
  end
end

def split_and_set(restaurant_hours, hours_set, day)
  hours = /\d.*/.match(hours_set)[0]
  open_hours = hours.split('-')[0].strip
  closed_hours = hours.split('-')[1].strip
  restaurant_hours[day]['open'] = convert_to_military(open_hours)
  restaurant_hours[day]['closed'] = convert_to_military(closed_hours)
end

def convert_to_military(time)
  return nil if time.nil?

  raw_time = time.split(' ')[0]
  am_or_pm = time.split(' ')[1]
  hour = raw_time.split(':')[0]
  min = raw_time.split(':')[1]
  hour = (hour.to_i + 12).to_s if am_or_pm == 'pm'
  hour + (min || '00')
end

csv = CSV.parse(File.read(Rails.root.join('lib', 'seeds', 'restaurant_times.csv')), headers: false)
csv.each do |row|
  restaurant = Restaurant.new(name: row[0])
  restaurant_hours = {
    'monday' => { 'open' => nil, 'closed' => nil },
    'tuesday' => { 'open' => nil, 'closed' => nil },
    'wednesday' => { 'open' => nil, 'closed' => nil },
    'thursday' => { 'open' => nil, 'closed' => nil },
    'friday' => { 'open' => nil, 'closed' => nil },
    'saturday' => { 'open' => nil, 'closed' => nil },
    'sunday' => { 'open' => nil, 'closed' => nil },
  }

  hours_sets = row[1].split('/')
  hours_sets.each do |hours_set|
    days = /^[^\d]*/.match(hours_set)[0].strip
    day_ranges = days.split(',')
    if day_ranges.length > 1
      day_ranges.each do |range|
        days_range = range.strip.split('-')
        set_hours(days_range, hours_set, restaurant_hours)
      end
    else
      days_range = day_ranges[0].strip.split('-')
      set_hours(days_range, hours_set, restaurant_hours)
    end
  end

  restaurant.hours = restaurant_hours
  restaurant.save!
end
