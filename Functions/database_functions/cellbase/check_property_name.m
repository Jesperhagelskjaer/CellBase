function [] = check_property_name(Lpropnames,g)

if (g.add == 1)
    for i = 1:Lpropnames
        prevanal = findanalysis(g.property_names{i});  % look for property in CellBase
        if prevanal
            error('addanalysis:propertyExists','ADDANALYSIS: Property name already exists at position %d. Delete first or choose a different one.',prevanal)
        end
    end
end
end


