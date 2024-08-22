close
clear
clc

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

T_ref = 20;
T_reelle = [5.6, 8.4, 10.7, 12.3, 17.8, 20.5, 23, 23.3, 17.5, 16.3, 10.2, 5.7]; % Température moyenne mensuelle

Q_murs1 = U_murs1*A_mur1*max(0,(T_ref-T_reelle));
Q_murs2 = U_murs2*A_mur2*max(0,(T_ref-T_reelle));
Q_fenetres = U_vitres*A_fenetres*max(0,(T_ref-T_reelle));

Q_ponts = 2*(48.06+23.03)*(U_tt+U_pii+U_pie+U_amei+U_amee)*max(0,(T_ref-T_reelle));

Q_CTA = V*rau*cp*max(0,(T_ref-T_reelle));

Q_total = Q_murs1+Q_murs2+Q_fenetres+Q_ponts+Q_CTA; % Puissance (W)

Q = Q_total/1000; % Puissance (kW)

heures = 24;
mois = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]; % Nombre de jours par mois
efficacite = 0.89; % Efficacité du système de chauffage

E_quotidienne = Q*heures;

E_mensuelle = E_quotidienne.*mois; % Energie (kWh)

E_mensuelle = E_mensuelle/efficacite;

E_mensuelle = E_mensuelle/1000; % Energie (MWh)

E_annuelle = sum(E_mensuelle);

chauffage_reel_2022 = 14.89/100*[455000, 378000, 331000, 229000, 8000, 0, 0, 0, 0, 0, 477000, 300000]; % kWh

E_reelle = chauffage_reel_2022/1000;

figure
plot(E_reelle)
hold on
plot(E_mensuelle)
xlabel('Mois')
ylabel('Consommation (MWh)')
legend('Réelle','Simulation')
title('Consommation énergétique mensuelle en 2022')
