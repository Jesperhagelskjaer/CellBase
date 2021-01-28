function [TSpikes_mc] = loadMClust(t_start)

global f

count = 0;

for bd = 1:8
    while 1      
        try %could be made into a isfile instead of a try catch end
            load(strcat(par.path,sprintf('/TT%d_%02d',bd-1,count))); %start from zero TT0
            count = count + 1;
        catch
            break %break out of the while 1 loop
        end
        TSpikes_mc{1,count} = round((tSpikes-t_start/f.fs)*f.fs);
        %datum.tS_mc{bd,count} = round((tSpikes)*par.filtering{3});
    end
end


end
