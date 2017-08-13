
%Extracts the index from the designated row
function index= find_index(specific_row, specific_string) 
comparison = strcmp(specific_row, specific_string);
index = find(comparison);


end


