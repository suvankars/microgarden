class Ride < ActiveRecord::Base
   # Actually monkey-patched Integer to convert to_cm to_feet
  Integer.include CoreExtensions::Integer
  
  SHORT_DISTANCE = 3

  filterrific(
  default_filter_params: { sorted_by: 'created_at_desc' },
  available_filters: [
    :sorted_by,
    :search_query,
    :with_rider_height,
    :with_frame_size,
    :with_subcategory_id,
    :with_created_at_gte,
    :with_morning_rental_lt
  ]
  )

  belongs_to :category
  belongs_to :subcategory

  geocoded_by :address
  belongs_to :user   
  
  # TBD
  # def address
  #   [street, city, state, country].compact.join(', ')
  # end

  # auto-fetch coordinates
  after_validation :geocode
  
  has_many :schedules

  scope :with_created_at_gte, lambda { |ref_date|
    where('rides.created_at >= ?', ref_date)
  }

  scope :with_subcategory_id, lambda { |subcategory_id|
    # Filters students with any of the given subcategory_id
    where(subcategory_id: [*subcategory_id])
    
  }

  scope :with_rider_height, lambda { |rider_height|
       where(rider_height: [*rider_height])
  }

  scope :with_frame_size, lambda { |frame_size|
       where(frame_size: [*frame_size])
  }

  scope :with_morning_rental_lt, lambda { |morning_rental|
    #Find a close amount like +25 -50 of your budget 

    where('rides.morning_rental BETWEEN ? AND ?', morning_rental-50, morning_rental + 25)
  }

  def self.slot_prices 
    Choices['price'].each.collect do |price| 
      price
    end   
  end

  def self.options_for_select
    slot_prices.map{ |p| ["#{p} /slot", p] }
  end

  def nearby_me
    self.nearbys(SHORT_DISTANCE)
  end
end


