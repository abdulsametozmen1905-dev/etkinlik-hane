class User < ApplicationRecord
    has_secure_password
    
    has_many :ratings, dependent: :destroy
    has_many :events, dependent: :destroy
    has_many :registrations, dependent: :destroy
    has_many :registered_events, through: :registrations, source: :event
    has_many :comments, dependent: :destroy

    validates :email, presence: true, uniqueness: true
end