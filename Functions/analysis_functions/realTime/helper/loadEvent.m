function [TTLs,TimestampsEvent] = loadEvent(path)

[TimestampsEvent, EventIDs, TTLs, Extras, EventStrings, HeaderEvent] = Nlx2MatEV(path, [1 1 1 1 1], 1, 1, [] );   
   
end



