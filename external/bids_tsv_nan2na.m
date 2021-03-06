function t = bids_tsv_nan2na(t)
%
% function t = bids_tsv_nan2na(t)
% function replaces NaN in a table with n/a
%
% input: a table t that contains BIDS data (e.g._electrodes.tsv)
%
% output: the same table t with NaN raplaced with n/a
%
%
% Tables entried may have NaN for missing values, but should be written as
% a n/a in the bids .tsv file. Therefore, this function replaces all NaNs
% in a table with n/a.
%
%
% Dora Hermes, 2017

% get the variable names from a table (columns):
var_names= t.Properties.VariableNames;

% loop through the columns:
for kk = 1:length(var_names)
    thisColumn = t.(var_names{kk}); % get column in table
    
    % test whether this column is a cell or a vector
    if iscell(thisColumn)
        for ll = 1:length(thisColumn) % run through cell, test for every entry
            if isstring(thisColumn{ll})
                if isequal(thisColumn{ll},'NaN') % is there a NaN?
                    thisColumn{ll}='n/a'; % replace with 'n/a'
                end
            elseif isnumeric(thisColumn{ll})
                if  isequal(num2str(thisColumn{ll}),'NaN')
                    thisColumn{ll}= 'n/a'; % replace with 'n/a'
                else
                    thisColumn{ll} = num2str(thisColumn{ll});
                end
            end
        end
    elseif isvector(thisColumn) && ~isdatetime(thisColumn)
        thisColumn = num2cell(thisColumn); % make it a cell array
        thisColumn(isnan(t.(var_names{kk}))) = {'n/a'}; % replace NaN with 'n/a'
    elseif isdatetime(thisColumn)
        thisColumn = datestr(thisColumn);
        thisColumn_cell = cell(size(thisColumn,1),1);

        for ll = 1:size(thisColumn,1)
            thisColumn_cell{ll} = thisColumn(ll,:);
        end

    else
        disp('column is not a cell, vector or datetime') % not sure whether this is possible, check anyways for sensible debug
    end
    t.(var_names{kk}) = thisColumn; % put back in the table
end
