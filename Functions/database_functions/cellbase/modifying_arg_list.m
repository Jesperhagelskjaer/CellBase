function [arg_list,range] = modifying_arg_list(CELLIDLIST,varargin)

data_PN = varargin(find(strcmp(varargin,'property_names'))+1);

idx = 0;
data_AL = {};
if find(strcmp(varargin,'arglist'))
    data_AL = varargin(find(strcmp(varargin,'arglist'))+1);
    data_AL = data_AL{:};
    idx = find(strcmp(data_AL,'cells'));
end

if any(idx)
    range               = [0 data_AL{idx+1}];
    data_AL(idx:idx+1)  = [];
else
    range = 0:numel(CELLIDLIST);
end

arg_list{1} = data_PN{:};
arg_list{2} = data_AL;

end
