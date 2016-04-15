class Schedule < ActiveRecord::Base
  belongs_to :list
  
  MORNING_START = 6
  MORNING_END = 9
  EVENING_START = 16
  EVENING_END = 20

  scope :between, -> (start_time, end_time) { where('
                (start_time >= :start_time and end_time <= :end_time) or
                (start_time >= :start_time and end_time > :end_time and start_time <= :end_time) or
                (start_time <= :start_time and end_time >= :start_time and end_time <= :end_time) or
                (start_time <= :start_time and end_time > :end_time)',
                start_time: format_date(start_time), end_time: format_date(end_time) ) }

  def self.format_date(date_time)
    date_time.to_time.to_formatted_s(:db)
  end


  def format(list)
      {
        :id => self.id,
        :title => list.ride_title,
        :start => start_time.rfc822,
        :end => end_time.rfc822,
        :allDay => self.all_day,
        :recurring => false,
        :url => Rails.application.routes.url_helpers.list_schedule_path(list, self)
        #:color => "red"
      }
  end

  def set_morning_slot
    self.start_time = self.start_time.change({ hour: MORNING_START, min: 0, sec: 0 })
    self.end_time = self.end_time.change({ hour: MORNING_END, min: 0, sec: 0 })
  end

  def set_evening_slot
    self.start_time = self.start_time.change({ hour: EVENING_START, min: 0, sec: 0 })
    self.end_time = self.end_time.change({ hour: EVENING_END, min: 0, sec: 0 })
  end
end
