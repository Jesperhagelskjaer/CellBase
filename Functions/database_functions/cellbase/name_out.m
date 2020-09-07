function [] = name_out(Lpropnames,funhandle,cellnum)

if Lpropnames == 1
    noutSTR = 'y';
else
    noutSTR = 'ies';
end
fprintf('\nADDANALYSIS done.\n  %s executed on %d cells creating %d new propert%s.\n',func2str(funhandle),cellnum,Lpropnames,noutSTR);

end

