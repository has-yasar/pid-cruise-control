% =========================================================================
% Bandırma Onyedi Eylül Üniversitesi - Mühendislik ve Doğa Bilimleri Fak.
% Elektrik-Elektronik Mühendisliği Bölümü - Otomatik Kontrol Ödevi
% C Bölümü: G1(s) ve G2(s) Birim Geri Beslemeli Sistem Analizleri
% Öğrenci: Yaşar Has (2311506210)
% =========================================================================

clear; clc; close all;

%% 1. Sistem 1 (G1) ve Sistem 2 (G2) Açık Çevrim Polinom Tanımlamaları
% G1(s) = 3 / (s*(s+1)*(s+2)) = 3 / (s^3 + 3s^2 + 2s)
num1 = [3];
den1 = conv([1 0], conv([1 1], [1 2])); % s^3 + 3s^2 + 2s polinom çarpımı
sys_G1 = tf(num1, den1);

% G2(s) = 7 / (s*(s+1)*(s+2)) = 7 / (s^3 + 3s^2 + 2s)
num2 = [7];
den2 = den1;
sys_G2 = tf(num2, den2);

%% 2. Kapalı Çevrim Transfer Fonksiyonları (Unity Feedback, H=1)
% T(s) = G(s) / (1 + G(s))
sys_T1 = feedback(sys_G1, 1);
sys_T2 = feedback(sys_G2, 1);

disp('=====================================================');
disp('Sistem 1 Kapalı Çevrim Transfer Fonksiyonu T1(s):');
sys_T1
disp('Sistem 2 Kapalı Çevrim Transfer Fonksiyonu T2(s):');
sys_T2

%% 3. Kapalı Çevrim Kutuplarının (Poles) Hesaplanması
poles1 = pole(sys_T1);
poles2 = pole(sys_T2);

disp('=====================================================');
disp('Sistem 1 Kapalı Çevrim Kutupları:');
disp(poles1);
disp('Sistem 2 Kapalı Çevrim Kutupları:');
disp(poles2);

%% 4. Adım Cevabı Metriklerinin Çıkarılması (stepinfo)
info1 = stepinfo(sys_T1, 'SettlingTimeThreshold', 0.02);
ess1 = 1 - dcgain(sys_T1); % Kalıcı durum hatası hesaplama (e_ss)

disp('=====================================================');
disp('--- Sistem 1 (G1) Zaman Domaini Metrikleri ---');
fprintf('Yükselme Zamanı (Rise Time %%10-90): %.4f saniye\n', info1.RiseTime);
fprintf('Tepe Zamanı (Peak Time): %.4f saniye\n', info1.PeakTime);
fprintf('Yerleşme Zamanı (Settling Time %%2): %.4f saniye\n', info1.SettlingTime);
fprintf('Maksimum Aşım Oranı (Overshoot): %%.4f%%\n', info1.Overshoot);
fprintf('Kalıcı Durum Hatası (e_ss): %.4f (~Sıfır Hata / Tip-1)\n\n', ess1);

disp('--- Sistem 2 (G2) Zaman Domaini Metrikleri ---');
disp('Sistem kararsız (sağ yarı düzlem köklü) olduğu için geçici durum metrikleri tanımsızdır.');
disp('=====================================================');