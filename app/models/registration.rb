class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :event

  scope :confirmed, -> { where(status: "registered") }
  scope :waitlisted, -> { where(status: "waitlisted") }

  def waitlisted?
    status == "waitlisted"
  end

  def confirmed?
    status == "registered"
  end
end