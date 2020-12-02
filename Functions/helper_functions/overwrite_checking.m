function [bool] = overwrite_checking(bool,name,session,name_old,session_old)

if bool
    if ~(strcmp(name_old,name) && strcmp(session_old,session))
        bool = 1;
    else
        bool = 0;
    end
end
end

