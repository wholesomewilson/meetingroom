class User < ApplicationRecord
  include Clearance::User

  has_many :bookings
  has_many :rooms, through: :bookings
  accepts_nested_attributes_for :bookings
  
  validates :name, presence: true
end
