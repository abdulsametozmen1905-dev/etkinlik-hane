class Event < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :registrations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_one_attached :cover_image

  # Scope'lar (Filtreler)
  scope :published, -> { where(published: true) }
  scope :drafts, -> { where(published: false) }
  scope :upcoming, -> { where("date_time >= ?", Time.current).order(date_time: :asc) }

  # Validasyonlar
  validates :title, :description, :date_time, :location, :quota, presence: true
  validates :quota, numericality: { only_integer: true, greater_than: 0 }

  # Taslak kontrolü
  def draft?
    !published?
  end

  # Kontenjan ve Bekleme Listesi Metodları
  def confirmed_registrations_count
    registrations.confirmed.count
  end

  def full?
    confirmed_registrations_count >= quota
  end

  def remaining_quota
    [quota - confirmed_registrations_count, 0].max
  end

  # Ortalama Puan Metodu
  def average_rating
    return 0 if ratings.empty?
    ratings.average(:score).to_f.round(1)
  end
end