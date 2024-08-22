% Données initiales
U_murs1 = 0.28; % Coefficient de transmission thermique (W/m².K)
U_murs2 = 0.28;
U_vitres = 1.0;

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

T_ref = 18;
T_reelle = [6.5, 7.5, 10, 11.5, 16.1, 22.4, 21.2, 20.9, 21.4, 15.6, 9.8, 8.1];

% Calcul des puissances
Q_murs1 = U_murs1 * A_mur1 * max(0, (T_ref - T_reelle));
Q_murs2 = U_murs2 * A_mur2 * max(0, (T_ref - T_reelle));
Q_fenetres = U_vitres * A_fenetres * max(0, (T_ref - T_reelle));

Q_ponts = 2 * (48.06 + 23.03) * (U_tt + U_pii + U_pie + U_amei + U_amee) * max(0, (T_ref - T_reelle));

Q_CTA = V * rau * cp * max(0, (T_ref - T_reelle));

Q_total = Q_murs1 + Q_murs2 + Q_fenetres + Q_ponts + Q_CTA; % Puissance (W)

Q = Q_total / 1000; % Puissance (kW)

% Calcul des énergies
heures = 24;
mois = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]; % Nombre de jours par mois
efficacite = 0.89; % Efficacité du système de chauffage

E_quotidienne = Q * heures; % Energie (kWh)

E_mensuelle = E_quotidienne .* mois; % Energie (kWh)

E_mensuelle = E_mensuelle / efficacite;

E_mensuelle = E_mensuelle / 1000; % Energie (MWh)

E_annuelle = sum(E_mensuelle);

% Consommation réelle
chauffage_reel_2023 = 14.89 / 100 * [277000, 228000, 177000, 203000, 41000, 15000, 0, 0, 38000, 56000, 240000, 257000];

E_reelle = chauffage_reel_2023 / 1000;

% Plot de la consommation mensuelle
figure
plot(E_reelle, 'o-', 'LineWidth', 2)
hold on
plot(E_mensuelle, 's-', 'LineWidth', 2)
xlabel('Mois')
ylabel('Consommation (MWh)')
legend('Réelle', 'Simulation')
title('Consommation énergétique mensuelle en 2023')

% Calcul des sommes annuelles
somme_reelle = sum(E_reelle);
somme_simulation = sum(E_mensuelle);

% Plot de l'histogramme des sommes annuelles
figure
bar([somme_reelle, somme_simulation])
set(gca, 'xticklabel', {'Réelle', 'Simulation'})
ylabel('Consommation annuelle (MWh)')
title('Consommation énergétique annuelle en 2023')

