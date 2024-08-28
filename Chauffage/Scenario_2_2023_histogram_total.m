% Efface les données précédentes et ferme toutes les figures
clear;
close all;
clc;

% Données initiales pour le scénario 2023
U_murs1 = 0.38; % Coefficient de transmission thermique (W/m².K)
U_murs2 = 0.38;
U_vitres = 2.70;

A_fenetres = 137.72; % Surface des fenêtres (m²)
A_mur1 = 217.73;
A_mur2 = A_mur1;

U_tt = 0.79; % Ponts thermiques toiture terrases
U_pii = 0.99; % Ponts thermiques planchers intermédiaires intérieurs
U_pie = 0.07; % Ponts thermiques planchers intermédiaires extérieurs
U_amei = 0.03; % Ponts thermiques angles murs extérieurs intérieurs
U_amee = 0.015; % Ponts thermiques angles murs extérieurs extérieurs

V = 4.31; % débit d'air de la CTA (m^3/s)
rau = 1.2; % kg/m^3
cp = 1005; % J/(kg.dT)

T_reelle = [6.5, 7.5, 10, 11.5, 16.1, 22.4, 21.2, 20.9, 21.4, 15.6, 9.8, 8.1]; % Température moyenne mensuelle en 2023

% Simulation sans régulation
T_ref = 17;

Q_murs1 = U_murs1 * A_mur1 * max(0, (T_ref - T_reelle));
Q_murs2 = U_murs2 * A_mur2 * max(0, (T_ref - T_reelle));
Q_fenetres = U_vitres * A_fenetres * max(0, (T_ref - T_reelle));

Q_ponts = 2 * (48.06 + 23.03) * (U_tt + U_pii + U_pie + U_amei + U_amee) * max(0, (T_ref - T_reelle));

Q_CTA = V * rau * cp * max(0, (T_ref - T_reelle));

Q_total = Q_murs1 + Q_murs2 + Q_fenetres + Q_ponts + Q_CTA; % Puissance (W)

Q = Q_total / 1000; % Puissance (kW)

heures = 24;
mois = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]; % Nombre de jours par mois
efficacite = 0.89; % Efficacité du système de chauffage

E_quotidienne = Q * heures;

E_mensuelle = E_quotidienne .* mois; % Energie (kWh)

E_mensuelle = E_mensuelle / efficacite;

E_mensuelle = E_mensuelle / 1000; % Energie (MWh)

E_annuelle_sans_regulation = sum(E_mensuelle);

% Simulation avec régulation
% Utilisation des nouveaux coefficients de transmission thermique
U_murs1_avec_reg = 0.28; % Coefficient de transmission thermique (W/m².K)
U_murs2_avec_reg = 0.28;
U_vitres_avec_reg = 1.00;

T_conf = 16;

Q_murs1 = U_murs1_avec_reg * A_mur1 * max(0, (T_conf - T_reelle));
Q_murs2 = U_murs2_avec_reg * A_mur2 * max(0, (T_conf - T_reelle));
Q_fenetres = U_vitres_avec_reg * A_fenetres * max(0, (T_conf - T_reelle));

Q_ponts = 2 * (48.06 + 23.03) * (U_tt + U_pii + U_pie + U_amei + U_amee) * max(0, (T_conf - T_reelle));

Q_CTA = V * rau * cp * max(0, (T_conf - T_reelle));

Q_total = Q_murs1 + Q_murs2 + Q_fenetres + Q_ponts + Q_CTA; % Puissance (W)

Q_conf = Q_total / 1000; % Puissance (kW)

h_conf = 13;

T_eco = 10;

Q_murs1 = U_murs1_avec_reg * A_mur1 * max(0, (T_eco - T_reelle));
Q_murs2 = U_murs2_avec_reg * A_mur2 * max(0, (T_eco - T_reelle));
Q_fenetres = U_vitres_avec_reg * A_fenetres * max(0, (T_eco - T_reelle));

Q_ponts = 2 * (48.06 + 23.03) * (U_tt + U_pii + U_pie + U_amei + U_amee) * max(0, (T_eco - T_reelle));

Q_CTA = V * rau * cp * max(0, (T_conf - T_reelle));

Q_total = Q_murs1 + Q_murs2 + Q_fenetres + Q_ponts + Q_CTA; % Puissance (W)

Q_eco = Q_total / 1000; % Puissance (kW)

h_eco = 11;

E_conf = Q_conf * h_conf;
E_eco = Q_eco * h_eco;

E_quotidienne_reg = E_conf + E_eco;

mois = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]; % Nombre de jours par mois
efficacite = 0.89; % Efficacité du système de chauffage

E_mensuelle_reg = E_quotidienne_reg .* mois; % Energie (kWh)

E_mensuelle_reg = E_mensuelle_reg / efficacite;

E_mensuelle_reg = E_mensuelle_reg / 1000; % Energie (MWh)

E_annuelle_reg = sum(E_mensuelle_reg);

% Consommation énergétique réelle pour 2023
chauffage_reel_2023 = 14.89 / 100 * [277000, 228000, 177000, 203000, 41000, 15000, 0, 0, 38000, 56000, 240000, 257000];

E_reelle = chauffage_reel_2023 / 1000;

% Création de l'histogramme pour la consommation annuelle
figure;
b = bar([1 2], [E_annuelle_sans_regulation, E_annuelle_reg], 'FaceColor', 'flat');
b.CData(1, :) = [0 0.4470 0.7410]; % Bleu pour la consommation sans régulation
b.CData(2, :) = [0.8500 0.3250 0.0980]; % Orange pour la consommation avec régulation
set(gca, 'XTickLabel', {'Sans modification', 'Avec modification'});
ylabel('Consommation annuelle (MWh)');
ylim([0,275]);
title('Consommation énergétique annuelle en 2023');

% Ajouter les valeurs au-dessus des barres
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1, ytips1, labels1, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
