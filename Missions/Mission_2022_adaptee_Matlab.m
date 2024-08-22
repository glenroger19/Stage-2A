% Close all figures, clear workspace and command window
close all;
clear;
clc;

% Utilisation de textscan
file_path = 'mission_2022_adaptee.csv';

fid = fopen(file_path, 'r');
data_textscan = textscan(fid, '%s %f %f', 'Delimiter', ';');
fclose(fid);

disp('Données lues avec textscan:');
disp(data_textscan);

% Conversion des données en tableau pour un accès plus facile
data = [data_textscan{1}, num2cell(data_textscan{2}), num2cell(data_textscan{3})];

disp('Données converties:');
disp(data);

carbone = 0;

% Calcul des émissions de carbone
for i = 1:size(data, 1)
    mode_transport = data{i, 1};
    distance = data{i, 2};
    passagers = data{i, 3};
    
    if strcmp(mode_transport, 'Avion')
        if distance < 1000
            carbone = carbone + distance * 0.2586 * passagers;
        elseif distance >= 1000 && distance < 35000
            carbone = carbone + distance * 0.1875 * passagers;
        else
            carbone = carbone + distance * 0.152 * passagers;
        end
    elseif strcmp(mode_transport, 'Train')
        if distance < 200
            carbone = carbone + distance * 0.018 * passagers;
        else
            carbone = carbone + distance * 0.037 * passagers;
        end
    elseif strcmp(mode_transport, 'Voiture')
        carbone = carbone + distance * 0.2156 * passagers;
    end
end

carbone = carbone / 1000; % Conversion en tonnes

disp(['Émissions de carbone: ', num2str(carbone), ' tonnes']);
