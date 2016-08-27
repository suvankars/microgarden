class Schedule < ActiveRecord::Base
  belongs_to :ride
  
  MORNING_START = 6  #(time)
  MORNING_END = 9
  EVENING_START = 16
  EVENING_END = 20
  DAILY_START = 6
  DAILY_END = 20
  WEEK_DURATION = 6  #(6 day will add to start date)

  scope :between, -> (start_time, end_time) { where('
                (start_time >= :start_time and end_time <= :end_time) or
                (start_time >= :start_time and end_time > :end_time and start_time <= :end_time) or
                (start_time <= :start_time and end_time >= :start_time and end_time <= :end_time) or
                (start_time <= :start_time and end_time > :end_time)',
                start_time: format_date(start_time), end_time: format_date(end_time) ) }

  def self.format_date(date_time)
    date_time.to_time.to_formatted_s(:db)
  end


  def format(ride)
      schedule_hash = {
        :id => self.id,
        :title => ride.title,
        :start => self.start_time.iso8601,
        :end => self.end_time.iso8601,
        :recurring => false,
        #:allDay => self.all_day,
        :daily_ride => self.all_day,
        :morning_ride => self.morning_ride,
        :evening_ride => self.evening_ride,
        :weekly_ride => self.weekly_ride,
        :booked => self.booked,
        #:url => Rails.application.routes.url_helpers.ride_schedule_path(ride, self)
        :color => "#71A805"
      }
      if self.booked 
        schedule_hash[:color] = "rgba(233, 167, 0, 0.70);"
      end
      if self.start_time < Time.now 
        schedule_hash[:color] = "red"
      end
      schedule_hash
  end

  def set_morning_slot
    self.start_time = self.start_time.change({ hour: MORNING_START, min: 0, sec: 0 })
    self.end_time = self.end_time.change({ day: self.start_time.day, hour: MORNING_END, min: 0, sec: 0 })
  end

  def set_evening_slot
    self.start_time = self.start_time.change({ hour: EVENING_START, min: 0, sec: 0 })
    self.end_time = self.end_time.change({ day: self.start_time.day, hour: EVENING_END, min: 0, sec: 0 })
  end

  def set_daily_slot
    self.start_time = self.start_time.change({ hour: DAILY_START, min: 0, sec: 0 })
    self.end_time = self.end_time.change({day: self.start_time.day,  hour: DAILY_END, min: 0, sec: 0 })
  end

  def set_weekly_slot
    self.start_time = self.start_time.change({ hour: DAILY_START, min: 0, sec: 0 })
    after_a_week = self.start_time + WEEK_DURATION.days
    self.end_time = self.end_time.change({day: after_a_week.day, month: after_a_week.month, year: after_a_week.year, hour: DAILY_END, min: 0, sec: 0 })
  end
end
