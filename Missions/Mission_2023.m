% Clear workspace and close all figures
clear;
clc;

% Lecture des données de 2023
file_path_2023 = 'mission_2023.csv';
fid_2023 = fopen(file_path_2023, 'r');
data_2023_textscan = textscan(fid_2023, '%s %f %f', 'Delimiter', ';');
fclose(fid_2023);

% Lecture des données de 2023 adaptée
file_path_2023_adaptee = 'mission_2023_adaptee.csv';
fid_2023_adaptee = fopen(file_path_2023_adaptee, 'r');
data_2023_adaptee_textscan = textscan(fid_2023_adaptee, '%s %f %f', 'Delimiter', ';');
fclose(fid_2023_adaptee);

% Calcul des émissions de carbone pour 2023
carbone_2023 = 0;
for i = 1:length(data_2023_textscan{1})
    mode_transport = data_2023_textscan{1}{i};
    distance = data_2023_textscan{2}(i);
    passagers = data_2023_textscan{3}(i);

    if strcmp(mode_transport, 'Avion')
        if distance < 1000
            carbone_2023 = carbone_2023 + distance * 0.2586 * passagers;
        elseif distance >= 1000 && distance < 35000
            carbone_2023 = carbone_2023 + distance * 0.1875 * passagers;
        else
            carbone_2023 = carbone_2023 + distance * 0.152 * passagers;
        end
    elseif strcmp(mode_transport, 'Train')
        if distance < 200
            carbone_2023 = carbone_2023 + distance * 0.018 * passagers;
        else
            carbone_2023 = carbone_2023 + distance * 0.0033 * passagers;
        end
    elseif strcmp(mode_transport, 'Voiture')
        carbone_2023 = carbone_2023 + distance * 0.2156 * passagers;
    end
end

carbone_2023 = carbone_2023 / 1000; % Conversion en tonnes
carbone_2023 = carbone_2023 - 2.99;

% Calcul des émissions de carbone pour 2023 adaptée
carbone_2023_adaptee = 0;
for i = 1:length(data_2023_adaptee_textscan{1})
    mode_transport = data_2023_adaptee_textscan{1}{i};
    distance = data_2023_adaptee_textscan{2}(i);
    passagers = data_2023_adaptee_textscan{3}(i);

    if strcmp(mode_transport, 'Avion')
        if distance < 1000
            carbone_2023_adaptee = carbone_2023_adaptee + distance * 0.2586 * passagers;
        elseif distance >= 1000 && distance < 35000
            carbone_2023_adaptee = carbone_2023_adaptee + distance * 0.1875 * passagers;
        else
            carbone_2023_adaptee = carbone_2023_adaptee + distance * 0.152 * passagers;
        end
    elseif strcmp(mode_transport, 'Train')
        if distance < 200
            carbone_2023_adaptee = carbone_2023_adaptee + distance * 0.018 * passagers;
        else
            carbone_2023_adaptee = carbone_2023_adaptee + distance * 0.0033 * passagers;
        end
    elseif strcmp(mode_transport, 'Voiture')
        carbone_2023_adaptee = carbone_2023_adaptee + distance * 0.2156 * passagers;
    end
end

carbone_2023_adaptee = carbone_2023_adaptee / 1000; % Conversion en tonnes
carbone_2023_adaptee = carbone_2023_adaptee - 2.99;

% Affichage des résultats
disp(['Émissions de carbone 2023: ', num2str(carbone_2023), ' tonnes']);
disp(['Émissions de carbone 2023 adaptée: ', num2str(carbone_2023_adaptee), ' tonnes']);

% Génération de l'histogramme
figure;
bar_values = [carbone_2023, carbone_2023_adaptee];
bar_handle = bar(bar_values, 'FaceColor', 'r'); % Mettre les barres en rouge
set(gca, 'xticklabel', {'2023', '2023 adaptée'});
ylabel('Émissions de carbone (t eCO2)');
title('Comparaison des émissions de carbone en 2023');

% Définir les limites de l'axe Y pour laisser de la place au texte
ylim([0 max(bar_values) * 1.2]);

% Ajouter les valeurs au-dessus de chaque barre
for i = 1:length(bar_values)
    text(i, bar_values(i), num2str(bar_values(i), '%.2f'), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 18); % Agrandir la taille du texte
end

