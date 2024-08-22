% Clear previous data and close all figures
clear;
close all;
clc;

% Données initiales pour la simulation sans amélioration
U_murs1_sans_am = 0.38; % Coefficient de transmission thermique (W/m².K)
U_murs2_sans_am = 0.38;
U_vitres_sans_am = 2.70;

A_fenetres = 137.72; % Surface des fenêtres (m²)
A_mur1 = 217.73;
A_mur2 = A_mur1;

U_tt = 0.79; % Ponts thermiques toiture terrasses
U_pii = 0.99; % Ponts thermiques planchers intermédiaires intérieurs
U_pie = 0.07; % Ponts thermiques planchers intermédiaires extérieurs
U_amei = 0.03; % Ponts thermiques angles murs extérieurs intérieurs
U_amee = 0.015; % Ponts thermiques angles murs extérieurs extérieurs

V = 4.31; % débit d'air de la CTA (m^3/s)
rau = 1.2; % kg/m^3
cp = 1005; % J/(kg.dT)

T_reelle = [6.5, 7.5, 10, 11.5, 16.1, 22.4, 21.2, 20.9, 21.4, 15.6, 9.8, 8.1]; % Température moyenne mensuelle pour 2023

% Simulation sans amélioration
T_ref = 17;

Q_murs1_sans_am = U_murs1_sans_am * A_mur1 * max(0, (T_ref - T_reelle));
Q_murs2_sans_am = U_murs2_sans_am * A_mur2 * max(0, (T_ref - T_reelle));
Q_fenetres_sans_am = U_vitres_sans_am * A_fenetres * max(0, (T_ref - T_reelle));

Q_ponts_sans_am = 2 * (48.06 + 23.03) * (U_tt + U_pii + U_pie + U_amei + U_amee) * max(0, (T_ref - T_reelle));

Q_CTA_sans_am = V * rau * cp * max(0, (T_ref - T_reelle));

Q_total_sans_am = Q_murs1_sans_am + Q_murs2_sans_am + Q_fenetres_sans_am + Q_ponts_sans_am + Q_CTA_sans_am; % Puissance (W)

Q_sans_am = Q_total_sans_am / 1000; % Puissance (kW)

heures = 24;
mois = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]; % Nombre de jours par mois
efficacite = 0.89; % Efficacité du système de chauffage

E_quotidienne_sans_am = Q_sans_am * heures;

E_mensuelle_sans_am = E_quotidienne_sans_am .* mois; % Energie (kWh)

E_mensuelle_sans_am = E_mensuelle_sans_am / efficacite;

E_mensuelle_sans_am = E_mensuelle_sans_am / 1000; % Energie (MWh)

E_annuelle_sans_am = sum(E_mensuelle_sans_am);

% Simulation avec amélioration
U_murs1_avec_am = 0.28; % Coefficient de transmission thermique (W/m².K)
U_murs2_avec_am = 0.28;
U_vitres_avec_am = 1.00;

Q_murs1_avec_am = U_murs1_avec_am * A_mur1 * max(0, (T_ref - T_reelle));
Q_murs2_avec_am = U_murs2_avec_am * A_mur2 * max(0, (T_ref - T_reelle));
Q_fenetres_avec_am = U_vitres_avec_am * A_fenetres * max(0, (T_ref - T_reelle));

Q_ponts_avec_am = 2 * (48.06 + 23.03) * (U_tt + U_pii + U_pie + U_amei + U_amee) * max(0, (T_ref - T_reelle));

Q_CTA_avec_am = V * rau * cp * max(0, (T_ref - T_reelle));

Q_total_avec_am = Q_murs1_avec_am + Q_murs2_avec_am + Q_fenetres_avec_am + Q_ponts_avec_am + Q_CTA_avec_am; % Puissance (W)

Q_avec_am = Q_total_avec_am / 1000; % Puissance (kW)

E_quotidienne_avec_am = Q_avec_am * heures;

E_mensuelle_avec_am = E_quotidienne_avec_am .* mois; % Energie (kWh)

E_mensuelle_avec_am = E_mensuelle_avec_am / efficacite;

E_mensuelle_avec_am = E_mensuelle_avec_am / 1000; % Energie (MWh)

E_annuelle_avec_am = sum(E_mensuelle_avec_am);

% Consommation réelle pour 2023 (en kWh)
chauffage_reel_2023 = 14.89 / 100 * [277000, 228000, 177000, 203000, 41000, 15000, 0, 0, 38000, 56000, 240000, 257000];

E_reelle = chauffage_reel_2023 / 1000; % Convertir en MWh

% Création de l'histogramme pour la consommation annuelle
figure;
b = bar([1 2], [E_annuelle_sans_am, E_annuelle_avec_am], 'FaceColor', 'flat');
b.CData(1, :) = [0 0.4470 0.7410]; % Bleu pour la consommation réelle
b.CData(2, :) = [0.8500 0.3250 0.0980]; % Orange pour la consommation sans amélioration
set(gca, 'XTickLabel', {'Sans amélioration', 'Avec amélioration'});
ylim([0,275]);
ylabel('Consommation annuelle (MWh)');
title('Consommation énergétique annuelle en 2023');

% Ajouter les valeurs au-dessus des barres
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(round(b(1).YData, 2));
text(xtips1, ytips1, labels1, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
