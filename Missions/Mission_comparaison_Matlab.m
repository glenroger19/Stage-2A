clear
clc

% Fonction pour lire les données et compter les modes de transport
function transport_count = count_modes(file_path)
    data = readtable(file_path, 'Delimiter', ';', 'ReadVariableNames', false);
    modes = data{:, 1}; % Extraire la première colonne qui contient les modes de transport
    quantities = data{:, 3}; % Extraire la troisième colonne
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

% Extraction des valeurs pour chaque comparaison
values_2022 = [count_2022.Avion, count_2022.Train, count_2022.Voiture];
values_2022_adaptee = [count_2022_adaptee.Avion, count_2022_adaptee.Train, count_2022_adaptee.Voiture];
values_2023 = [count_2023.Avion, count_2023.Train, count_2023.Voiture];
values_2023_adaptee = [count_2023_adaptee.Avion, count_2023_adaptee.Train, count_2023_adaptee.Voiture];

% Trouver la limite supérieure de l'axe y
max_y = max([values_2022, values_2023, values_2022_adaptee, values_2023_adaptee]);

% Création de l'histogramme pour comparer 2022 et 2023
figure;
bar_width = 0.35;
x = 1:3; % Pour les trois modes de transport

bar(x - bar_width/2, values_2022, bar_width, 'FaceColor', 'b', 'DisplayName', '2022');
hold on;
bar(x + bar_width/2, values_2023, bar_width, 'FaceColor', 'r', 'DisplayName', '2023');

set(gca, 'XTick', x, 'XTickLabel', {'Avion', 'Train', 'Voiture'});
ylabel('Nombre');
title('Comparaison des modes de transport entre 2022 et 2023');
legend('Location', 'northwest');

% Ajuster les limites de l'axe y pour inclure les barres de hauteur zéro
ylim([0 max_y + 1]);
hold off;

% Création de l'histogramme pour comparer 2022 adaptée et 2023 adaptée
figure;
bar_width = 0.35;
x = 1:3; % Pour les trois modes de transport

bar(x - bar_width/2, values_2022_adaptee, bar_width, 'FaceColor', 'b', 'DisplayName', '2022 adaptée');
hold on;
bar(x + bar_width/2, values_2023_adaptee, bar_width, 'FaceColor', 'r', 'DisplayName', '2023 adaptée');

set(gca, 'XTick', x, 'XTickLabel',{'Avion', 'Train', 'Voiture'});
ylabel('Nombre');
title('Comparaison des modes de transport entre 2022 adaptée et 2023 adaptée');
legend('Location', 'northwest');

% Ajuster les limites de l'axe y pour inclure les barres de hauteur zéro
ylim([0 max_y + 1]);
hold off;
