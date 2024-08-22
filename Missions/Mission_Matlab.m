% Clear workspace and close all figures
clear;
clc;

% Fonction pour lire les données et compter les modes de transport
function transport_count = count_modes(file_path)
    % Lire les données du fichier CSV
    fid = fopen(file_path, 'r');
    data = textscan(fid, '%s %f %f', 'Delimiter', ';', 'HeaderLines', 1);
    fclose(fid);
    
    modes = data{1}; % Extraire la première colonne qui contient les modes de transport
    quantities = data{3}; % Extraire la troisième colonne qui contient les quantités

    transport_count = struct('Avion', 0, 'Train', 0, 'Voiture', 0);

    for i = 1:length(modes)
        if strcmp(modes{i}, 'Avion')
            transport_count.Avion = transport_count.Avion + quantities(i);
        elseif strcmp(modes{i}, 'Train')
            transport_count.Train = transport_count.Train + quantities(i);
        elseif strcmp(modes{i}, 'Voiture')
            transport_count.Voiture = transport_count.Voiture + quantities(i);
        end
    end
end

% Comptage des modes de transport pour chaque fichier
count_2022 = count_modes('mission_2022.csv');
count_2022_adaptee = count_modes('mission_2022_adaptee.csv');
count_2023 = count_modes('mission_2023.csv');
count_2023_adaptee = count_modes('mission_2023_adaptee.csv');

% Extraction des valeurs
values_2022 = [count_2022.Avion, count_2022.Train, count_2022.Voiture];
values_2022_adaptee = [count_2022_adaptee.Avion, count_2022_adaptee.Train, count_2022_adaptee.Voiture];
values_2023 = [count_2023.Avion, count_2023.Train, count_2023.Voiture];
values_2023_adaptee = [count_2023_adaptee.Avion, count_2023_adaptee.Train, count_2023_adaptee.Voiture];

% Afficher les valeurs pour vérification
disp('2022:');
disp(values_2022);
disp('2022 adaptée:');
disp(values_2022_adaptee);
disp('2023:');
disp(values_2023);
disp('2023 adaptée:');
disp(values_2023_adaptee);

% Création de l'histogramme
figure;
hold on;

bar_width = 0.2;
x = 1:3; % Pour les trois modes de transport

bar(x - bar_width * 1.5, values_2022, bar_width, 'FaceColor', 'r');
bar(x - bar_width * 0.5, values_2022_adaptee, bar_width, 'FaceColor', 'g');
bar(x + bar_width * 0.5, values_2023, bar_width, 'FaceColor', 'b');
bar(x + bar_width * 1.5, values_2023_adaptee, bar_width, 'FaceColor', 'm');

set(gca, 'XTick', x, 'XTickLabel', {'Avion', 'Train', 'Voiture'});
ylabel('Quantité');
title('Comparaison des modes de transport entre 2022, 2022 adaptée, 2023 et 2023 adaptée');
legend({'2022', '2022 adaptée', '2023', '2023 adaptée'}, 'Location', 'northwest');

% Ajuster les limites de l'axe y pour inclure les barres de hauteur zéro
ylim([0 max([max(values_2022), max(values_2022_adaptee), max(values_2023), max(values_2023_adaptee)]) + 5]); % Ajustement pour inclure les barres de hauteur zéro
hold off;
