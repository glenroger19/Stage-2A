close
clear
clc

% Utilisation de textscan
file_path = 'mission_2022_adaptee.csv';

fid = fopen(file_path, 'r');
data_textscan = textscan(fid, '%s', 'Delimiter', ';');
fclose(fid);

disp('Données lues avec textscan:');
disp(data_textscan{1});

% Utilisation de csv2cell
pkg load io; % Assurez-vous que le paquet io est chargé
data = csv2cell(file_path, ';');

disp('Données lues avec csv2cell:');
disp(data);

carbone = 0;

for i = 1:44
  % Vérifiez si la première colonne contient 'Avion'
  if strcmp(data{i, 1}, 'Avion')
    % Vérifiez la valeur de la deuxième colonne et ajustez le carbone en conséquence
    if data{i, 2} < 1000
      carbone += data{i, 2} * 0.2586 * data{i,3};
    elseif data{i, 2} >= 1000 && data{i, 2} < 35000
      carbone += data{i, 2} * 0.1875 * data{i,3};
    else
      carbone += data{i, 2} * 0.152 * data{i,3};
    endif
  elseif strcmp(data{i, 1}, 'Train')
    % Vérifiez la valeur de la deuxième colonne et ajustez le carbone en conséquence
    if data{i, 2} < 200
      carbone += data{i, 2} * 0.018 * data{i,3};
    else
      carbone += data{i, 2} * 0.037 * data{i,3};
    endif
  elseif strcmp(data{i, 1}, 'Voiture')
    % Vérifiez la valeur de la deuxième colonne et ajustez le carbone en conséquence
    carbone += data{i, 2} * 0.2156 * data{i,3};
  endif
endfor

carbone = carbone/1000;
