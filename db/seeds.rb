Registration.destroy_all
Comment.destroy_all
Event.destroy_all
User.destroy_all
Category.destroy_all

# 1. 5 Kategori Oluştur
categories = ["Yazılım / Teknoloji", "Spor", "Eğitim / Seminer", "Sosyal", "Sanat"]
categories.each { |name| Category.create!(name: name) }

# 2. 10 Kullanıcı Oluştur
users = []
10.times do |i|
users << User.create!(email: "user#{i}@example.com", password: "password", admin: (i == 0))
end

# 3. 25 Etkinlik Oluştur (Geçmiş ve Gelecek)
categories = Category.all
users.each do |user|
5.times do |i|
    # Bazıları geçmiş, bazıları gelecek tarihli
    date = (i.even? ? 10.days.ago : 10.days.from_now)
    event = user.events.create!(
    title: "Etkinlik #{user.id}-#{i}",
    description: "Bu örnek bir etkinliktir.",
    location: "Ankara",
    date_time: date,
    quota: 10,
    category: categories.sample
    )
    
    # 4. Rastgele Kayıtlar (Etkinliklere kullanıcıları ekle)
    users.sample(3).each do |u|
    event.registrations.create!(user: u)
    end
end
end

puts "Veritabanı örnek verilerle dolduruldu!"