class Event < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :registrations, dependent: :destroy
  has_many :registered_users, through: :registrations, source: :user
  has_many :comments, dependent: :destroy

  has_one_attached :cover_image

  scope :upcoming, -> { where("date_time >= ?", Time.current).order(date_time: :asc) }

  validates :title, :description, :date_time, :location, :quota, presence: true
  validates :quota, numericality: { greater_than: 0 }
  validates :category_id, presence: { message: "seçilmelidir" }

  validate :date_cannot_be_in_the_past

  private

  def date_cannot_be_in_the_past
    if date_time.present? && date_time < Time.current
      errors.add(:date_time, "geçmiş bir zaman olamaz")
    end
  end
end