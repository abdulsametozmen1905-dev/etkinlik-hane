class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :event

  validates :score, presence: true, inclusion: { in: 1..5, message: "1 ile 5 arasında olmalıdır" }
  validates :user_id, uniqueness: { scope: :event_id, message: "bu etkinliğe zaten puan verdiniz" }
end