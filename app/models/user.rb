class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :products
  has_many :rides
  has_one :rider
  has_one :owner

  
  def is_owner?
    #Is user had any associated owner profile it will be true
    !self.owner.nil?
  end
  def is_rider?
    #Is user had any associated rider profile it will be true
    !self.rider.nil?
  end
end
