# PID Kontrollü Araç Hız Sabitleme Simülasyonu
### PID-Controlled Cruise Control Simulation with Cyberpunk UI & MATLAB Verification Model

Bu proje, Bandırma Onyedi Eylül Üniversitesi Elektrik-Elektronik Mühendisliği Bölümü **Otomatik Kontrol** dersi kapsamında geliştirilmiştir. Proje, bir aracın yokuş (eğim) ve rüzgar direnci gibi dinamik dış bozucu etkenler altında, sürücü tarafından belirlenen referans hızda (Set Point) sabit kalmasını sağlayan kapalı çevrim bir robust PID kontrol sistemidir.

---

## 🚀 Proje Bileşenleri

Depo içerisinde iki farklı katmanda doğrulama gerçekleştiren temel mühendislik kodları yer almaktadır:
1. **`index.html` (İnaktif Web Simülasyonu):** HTML5 Canvas API ve Chart.js kütüphaneleri kullanılarak geliştirilmiş, saniyede 60 kare diferansiyel denklem çözen siberpunk temalı canlı simülasyon arayüzü.
2. **`PID_cruise_control.m` (MATLAB Scripti):** Web arayüzündeki fizik motorunun ve Anti-Windup (Clamping) PID algoritmasının sürekli zaman domaininde doğrulanmasını sağlayan analitik simülasyon modeli.

---

## 🛠️ Matematiksel Dinamik Model

Araç hareket mekaniği, Newton'un ikinci kanununa ($F_{net} = m \cdot a$) dayalı doğrusal olmayan diferansiyel denklemlerle modellenmiştir:

$$m \cdot \frac{dv}{dt} = F_{motor} - F_{yokus} - F_{ruzgar} - F_{surtunme}$$

* **$F_{motor}$:** PID kontrolör tarafından üretilen gaz/fren aktüatör kuvveti.
* **$F_{yokus}$:** $m \cdot g \cdot \sin(\theta)$ yerçekimi bozucu etkisi (Disturbance).
* **$F_{ruzgar}$:** Hızın karesiyle orantılı gelişen aerodinamik sürtünme kuvveti.

---

## 💎 Gelişmiş Kontrol Özellikleri

* **Anti-Windup (Clamping) Algoritması:** Aktüatörün doyuma ulaştığı (dik yokuş veya ani ivmelenme) durumlarda integral hatasının sonsuza sarmasını engelleyen tam korumalı clamping mimarisi.
* **Çift Kanallı Canlı Grafik Analizi:** Hız zaman domaini cevabı ile kontrol sinyalinin (+Gaz / -Fren) eş zamanlı takibi.
* **Tip-1 Sistem Doğrulaması:** Kalıcı durum hatasını (steady-state error) basamak girişlerinde %0'a indiren integral entegrasyonu.

---

## 🧑‍💻 Geliştirici Bilgileri
* **Adı Soyadı:** Yaşar Has    
* **Bölüm:** Elektrik-Elektronik Mühendisliği Bölümü
