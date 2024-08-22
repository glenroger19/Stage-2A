% Clear workspace and close all figures
clear;
clc;

% Lecture des données de 2022
file_path_2022 = 'mission_2022.csv';
fid_2022 = fopen(file_path_2022, 'r');
data_2022_textscan = textscan(fid_2022, '%s %f %f', 'Delimiter', ';');
fclose(fid_2022);

% Lecture des données de 2022 adaptée
file_path_2022_adaptee = 'mission_2022_adaptee.csv';
fid_2022_adaptee = fopen(file_path_2022_adaptee, 'r');
data_2022_adaptee_textscan = textscan(fid_2022_adaptee, '%s %f %f', 'Delimiter', ';');
fclose(fid_2022_adaptee);

% Calcul des émissions de carbone pour 2022
carbone_2022 = 0;
for i = 1:length(data_2022_textscan{1})
    mode_transport = data_2022_textscan{1}{i};
    distance = data_2022_textscan{2}(i);
    passagers = data_2022_textscan{3}(i);

    if strcmp(mode_transport, 'Avion')
        if distance < 1000
            carbone_2022 = carbone_2022 + distance * 0.2586 * passagers;
        elseif distance >= 1000 && distance < 35000
            carbone_2022 = carbone_2022 + distance * 0.1875 * passagers;
        else
            carbone_2022 = carbone_2022 + distance * 0.152 * passagers;
        end
    elseif strcmp(mode_transport, 'Train')
        if distance < 200
            carbone_2022 = carbone_2022 + distance * 0.018 * passagers;
        else
            carbone_2022 = carbone_2022 + distance * 0.037 * passagers;
        end
    elseif strcmp(mode_transport, 'Voiture')
        carbone_2022 = carbone_2022 + distance * 0.2156 * passagers;
    end
end

carbone_2022 = carbone_2022 / 1000; % Conversion en tonnes
carbone_2022 = carbone_2022 - 0.69;

% Calcul des émissions de carbone pour 2022 adaptée
carbone_2022_adaptee = 0;
for i = 1:length(data_2022_adaptee_textscan{1})
    mode_transport = data_2022_adaptee_textscan{1}{i};
    distance = data_2022_adaptee_textscan{2}(i);
    passagers = data_2022_adaptee_textscan{3}(i);

    if strcmp(mode_transport, 'Avion')
        if distance < 1000
            carbone_2022_adaptee = carbone_2022_adaptee + distance * 0.2586 * passagers;
        elseif distance >= 1000 && distance < 35000
            carbone_2022_adaptee = carbone_2022_adaptee + distance * 0.1875 * passagers;
        else
            carbone_2022_adaptee = carbone_2022_adaptee + distance * 0.152 * passagers;
        end
    elseif strcmp(mode_transport, 'Train')
        if distance < 200
            carbone_2022_adaptee = carbone_2022_adaptee + distance * 0.018 * passagers;
        else
            carbone_2022_adaptee = carbone_2022_adaptee + distance * 0.037 * passagers;
        end
    elseif strcmp(mode_transport, 'Voiture')
        carbone_2022_adaptee = carbone_2022_adaptee + distance * 0.2156 * passagers;
    end
end

carbone_2022_adaptee = carbone_2022_adaptee / 1000; % Conversion en tonnes
carbone_2022_adaptee = carbone_2022_adaptee - 0.69;

% Affichage des résultats
disp(['Émissions de carbone 2022: ', num2str(carbone_2022), ' tonnes']);
disp(['Émissions de carbone 2022 adaptée: ', num2str(carbone_2022_adaptee), ' tonnes']);

% Génération de l'histogramme
figure;
bar_values = [carbone_2022, carbone_2022_adaptee];
bar_handle = bar(bar_values, 'FaceColor', 'r'); % Mettre les barres en rouge
set(gca, 'xticklabel', {'2022', '2022 adaptée'});
ylabel('Émissions de carbone (t eCO2)');
title('Comparaison des émissions de carbone en 2022');

% Définir les limites de l'axe Y pour laisser de la place au texte
ylim([0 max(bar_values) * 1.2]);

% Ajouter les valeurs au-dessus de chaque barre
for i = 1:length(bar_values)
    text(i, bar_values(i), num2str(bar_values(i), '%.2f'), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'bottom', ...
        'FontSize', 18); % Agrandir la taille du texte
end

