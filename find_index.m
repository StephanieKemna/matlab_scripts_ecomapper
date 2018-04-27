% find_index(specific_row, specific_string):
% Extracts the index of the designated row
% author: Jessica Gonzalez
function index = find_index(specific_row, specific_string)

comparison = strcmp(specific_row, specific_string);
index = find(comparison);

end