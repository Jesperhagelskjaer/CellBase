function [] = name_out(Lpropnames,funhandle,cellnum,g)

if Lpropnames == 1
    noutSTR = 'y';
else
    noutSTR = 'ies';
end

if g.add == 1
    fprintf('\nADDANALYSIS done.\n  %s executed on %d cells creating %d new propert%s.\n',func2str(funhandle),cellnum,Lpropnames,noutSTR);
else
    fprintf('\nADDANALYSIS done.\n')
end


end

