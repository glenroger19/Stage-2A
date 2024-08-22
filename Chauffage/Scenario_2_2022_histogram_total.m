% Clear previous data and close all figures
clear;
close all;
clc;

% Données initiales pour la simulation sans régulation
U_murs1_sans_reg = 0.38; % Coefficient de transmission thermique (W/m².K)
U_murs2_sans_reg = 0.38;
U_vitres_sans_reg = 2.70;

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

T_reelle = [5.6, 8.4, 10.7, 12.3, 17.8, 20.5, 23, 23.3, 17.5, 16.3, 10.2, 5.7]; % Température moyenne mensuelle

% Simulation sans régulation
T_ref = 20;

Q_murs1_sans_reg = U_murs1_sans_reg * A_mur1 * max(0, (T_ref - T_reelle));
Q_murs2_sans_reg = U_murs2_sans_reg * A_mur2 * max(0, (T_ref - T_reelle));
Q_fenetres_sans_reg = U_vitres_sans_reg * A_fenetres * max(0, (T_ref - T_reelle));

Q_ponts = 2 * (48.06 + 23.03) * (U_tt + U_pii + U_pie + U_amei + U_amee) * max(0, (T_ref - T_reelle));

Q_CTA = V * rau * cp * max(0, (T_ref - T_reelle));

Q_total_sans_reg = Q_murs1_sans_reg + Q_murs2_sans_reg + Q_fenetres_sans_reg + Q_ponts + Q_CTA; % Puissance (W)

Q_sans_reg = Q_total_sans_reg / 1000; % Puissance (kW)

heures = 24;
mois = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]; % Nombre de jours par mois
efficacite = 0.89; % Efficacité du système de chauffage

E_quotidienne_sans_reg = Q_sans_reg * heures;

E_mensuelle_sans_reg = E_quotidienne_sans_reg .* mois; % Energie (kWh)

E_mensuelle_sans_reg = E_mensuelle_sans_reg / efficacite;

E_mensuelle_sans_reg = E_mensuelle_sans_reg / 1000; % Energie (MWh)

E_annuelle_sans_regulation = sum(E_mensuelle_sans_reg);

% Simulation avec régulation (en gardant les valeurs de la régulation)
U_murs1_avec_reg = 0.28; % Coefficient de transmission thermique (W/m².K)
U_murs2_avec_reg = 0.28;
U_vitres_avec_reg = 1.00;

T_conf = 19;

Q_murs1_avec_reg = U_murs1_avec_reg * A_mur1 * max(0, (T_conf - T_reelle));
Q_murs2_avec_reg = U_murs2_avec_reg * A_mur2 * max(0, (T_conf - T_reelle));
Q_fenetres_avec_reg = U_vitres_avec_reg * A_fenetres * max(0, (T_conf - T_reelle));

Q_ponts_avec_reg = 2 * (48.06 + 23.03) * (U_tt + U_pii + U_pie + U_amei + U_amee) * max(0, (T_conf - T_reelle));

Q_CTA_avec_reg = V * rau * cp * max(0, (T_conf - T_reelle));

Q_total_avec_reg = Q_murs1_avec_reg + Q_murs2_avec_reg + Q_fenetres_avec_reg + Q_ponts_avec_reg + Q_CTA_avec_reg; % Puissance (W)

Q_conf = Q_total_avec_reg / 1000; % Puissance (kW)

h_conf = 13;

T_eco = 10;

Q_murs1_eco = U_murs1_avec_reg * A_mur1 * max(0, (T_eco - T_reelle));
Q_murs2_eco = U_murs2_avec_reg * A_mur2 * max(0, (T_eco - T_reelle));
Q_fenetres_eco = U_vitres_avec_reg * A_fenetres * max(0, (T_eco - T_reelle));

Q_ponts_eco = 2 * (48.06 + 23.03) * (U_tt + U_pii + U_pie + U_amei + U_amee) * max(0, (T_eco - T_reelle));

Q_CTA_eco = V * rau * cp * max(0, (T_conf - T_reelle));

Q_total_eco = Q_murs1_eco + Q_murs2_eco + Q_fenetres_eco + Q_ponts_eco + Q_CTA_eco; % Puissance (W)

Q_eco = Q_total_eco / 1000; % Puissance (kW)

h_eco = 11;

E_conf = Q_conf * h_conf;
E_eco = Q_eco * h_eco;

E_quotidienne_reg = E_conf + E_eco;

E_mensuelle_reg = E_quotidienne_reg .* mois; % Energie (kWh)

E_mensuelle_reg = E_mensuelle_reg / efficacite;

E_mensuelle_reg = E_mensuelle_reg / 1000; % Energie (MWh)

E_annuelle_reg = sum(E_mensuelle_reg);

chauffage_reel_2022 = 14.89 / 100 * [455000, 378000, 331000, 229000, 8000, 0, 0, 0, 0, 0, 477000, 300000]; % kWh

E_reelle = chauffage_reel_2022 / 1000;

% Création de l'histogramme pour la consommation annuelle
figure;
b = bar([1 2], [E_annuelle_sans_regulation, E_annuelle_reg], 'FaceColor', 'flat');
b.CData(1, :) = [0 0.4470 0.7410]; % Bleu pour la consommation sans régulation
b.CData(2, :) = [0.8500 0.3250 0.0980]; % Orange pour la consommation avec régulation
set(gca, 'XTickLabel', {'Sans régulation', 'Avec régulation'});
ylabel('Consommation annuelle (MWh)');
title('Consommation énergétique annuelle en 2022');

% Ajouter les valeurs au-dessus des barres
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1, ytips1, labels1, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center');
