% =========================================================================
% Bandırma Onyedi Eylül Üniversitesi - Mühendislik ve Doğa Bilimleri Fak.
% Elektrik-Elektronik Mühendisliği Bölümü - Otomatik Kontrol Ödevi
% PID Kontrollü Araç Hız Sabitleme (Cruise Control) MATLAB Simülasyonu
% Öğrenci: Yaşar Has (2311506210)
% =========================================================================

clear; clc; close all;

%% 1. Sistem ve Çevre Parametreleri (JS Motoru ile Birebir Eşit)
m = 1200;              % Araç Kütlesi (kg)
g = 9.81;              % Yerçekimi İvmesi (m/s^2)
Drag_Coeff = 1.8;      % JavaScript'teki birleşik hava ve yuvarlanma direnci

%% 2. Simülasyon Zaman Tanımları
Total_Time = 50;       % Toplam Simülasyon Süresi (saniye)
dt = 0.01;             % Örnekleme Zamanı (saniye)
t = 0:dt:Total_Time;
N = length(t);

%% 3. PID Kontrolör Kazançları ve Sınırları (Arayüzdeki Değerler)
Kp = 1.00;
Ki = 0.050;
Kd = 0.20;

MAX_ENGINE_FORCE = 8000;  % Maksimum Motor İtiş Gücü (Newton)
MAX_BRAKE_FORCE = 15000;  % Maksimum Frenleme Gücü (Newton)
Max_Integral = 50;        % Anti-Windup Sınırı

%% 4. Referans Sinyali ve Dinamik Bozucu Etki (Disturbance) Tanımı
V_Set_KMH = 90;            % Hedef Hız (km/h)
v_set = V_Set_KMH / 3.6;   % m/s dönüşümü

% Yol Eğimi Profili: 20. saniyeden sonra dik yokuş (+12 derece)
slope_deg = zeros(1, N);
slope_deg(t >= 20) = 12; 

%% 5. Durum Değişkenleri ve Bellek Ayırma
v = zeros(1, N);           % Anlık hız dizisi (m/s)
error_sum = 0;             % İntegral birikim değişkeni
last_error = 0;            % Türev için önceki hata

u_signal = zeros(1, N);    % Net Aktüatör Kuvvet Dizisi (Loglama için)

%% 6. Ana Simülasyon Döngüsü (Euler Entegrasyonu)
for k = 1:N-1
    % Anlık Hız Hatası Hesaplama
    current_error = v_set - v(k);
    
    % PID Terimleri
    P = Kp * current_error;
    
    % İntegral Sınırlandırması (Anti-Windup Clamping)
    error_sum = error_sum + current_error * dt;
    if error_sum > Max_Integral; error_sum = Max_Integral; end
    if error_sum < -Max_Integral; error_sum = -Max_Integral; end
    I = Ki * error_sum;
    
    % Türev Hesabı
    D = Kd * (current_error - last_error) / dt;
    last_error = current_error;
    
    % JavaScript Ölçeğindeki Ham Kontrol Sinyali
    controlSignal = P + I + D;
    
    % Kontrol Sinyalini Gaz ve Fren Yüzdelerine Dönüştürme
    if controlSignal > 0
        throttle = min(controlSignal, 1.0);
        brake = 0;
    else
        throttle = 0;
        brake = min(-controlSignal, 1.0);
    end
    
    % Fiziksel Motor ve Fren Kuvvetleri
    F_engine = throttle * MAX_ENGINE_FORCE;
    F_brake = -brake * MAX_BRAKE_FORCE * sign(v(k));
    
    % Çevresel Kuvvetler (Hava direnci ve Yerçekimi yokuş etkisi)
    theta_rad = slope_deg(k) * pi / 180;
    F_gravity = -m * g * sin(theta_rad);
    F_drag = -Drag_Coeff * v(k) * abs(v(k));
    
    % Toplam Net Kuvvet (F_net = F_engine + F_brake + F_gravity + F_drag)
    F_total = F_engine + F_brake + F_gravity + F_drag;
    
    % İvme ve Hız Entegrasyonu
    accel = F_total / m;
    v(k+1) = v(k) + accel * dt;
    
    if v(k+1) < 0
        v(k+1) = 0; % Geri kaçma engeli
    end
    
    % Grafik için Net Aktüatör Çıktısını Newton Olarak Kaydet
    u_signal(k) = F_engine + F_brake;
end
u_signal(end) = u_signal(end-1);

%% 7. Grafiksel Analiz ve Çıktılar
figure('Color', [1 1 1]);

% Hız Zaman Grafiği
subplot(2,1,1);
plot(t, v*3.6, 'b-', 'LineWidth', 2); hold on;
plot(t, ones(1,N)*V_Set_KMH, 'r--', 'LineWidth', 1.5);
grid on;
title('PID Hız Sabitleme Kapalı Çevrim Zaman Cevabı');
xlabel('Zaman (saniye)');
ylabel('Araç Hızı (km/h)');
legend('Gerçek Hız (V)', 'Hedef Hız (V_{set})', 'Location', 'SouthEast');
axis([0 Total_Time 0 160]);

% Kontrol Sinyali ve Yol Eğimi Grafiği
subplot(2,1,2);
yyaxis left;
plot(t, u_signal, 'g-', 'LineWidth', 1.5);
ylabel('Kontrolör Kuvvet Çıkışı (Newton)');
axis([0 Total_Time -4000 9000]);

yyaxis right;
plot(t, slope_deg, 'r-.', 'LineWidth', 1.5);
ylabel('Yol Eğimi (Derece)');
grid on;
title('Kontrol Sinyali ve Dış Bozucu Etki Analizi');
xlabel('Zaman (saniye)');
legend('Motor/Fren Kuvveti (u)', 'Yol Eğimi (\theta)', 'Location', 'NorthWest');