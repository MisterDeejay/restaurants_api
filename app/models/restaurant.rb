class Restaurant < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  def hours_as_hash
    subbed_hours = {}
    hours.each do |day, day_hours|
      subbed_hours[day] = JSON.parse(day_hours.gsub('=>',':').gsub(':nil',':null'))
    end

    subbed_hours
  end

  def closes_next_day?(wday)
    closed = hours_as_hash[wday]['closed'].to_i
    closed > 0 && closed < 1200
  end

  def open?(datetime)
    wday = Date::DAYNAMES[datetime.wday].downcase
    mil_time = datetime.strftime('%R').gsub(':', '').to_i
    open = hours_as_hash[wday]['open'].to_i
    closed = hours_as_hash[wday]['closed'].to_i
    open <= mil_time && (closes_next_day?(wday) ? closed <= mil_time : closed >= mil_time)
  end
end
