%% layout
function [rows,colums,indexes] = layout(M1num_pre)
    if M1num_pre<=4
        rows = 4;
    elseif M1num_pre<=8
        rows = 5;
    else
        rows = 6;
    end
    
    if M1num_pre<=4
        colums = M1num_pre*ones(1,M1num_pre);
        indexes = 1:M1num_pre;
    elseif M1num_pre==5
        colums = [2 2 3 3 3];
        indexes = [1 2 4 5 6];
    elseif M1num_pre==6
        colums = 3*ones(1,6);
        indexes = 1:6;
    elseif M1num_pre==7
        colums = [3 3 3 4 4 4 4];
        indexes = [1 2 3 5 6 7 8];
    elseif M1num_pre==8
        colums = 4*ones(1,8);
        indexes = 1:8;
    else
        colums = 3*ones(1,9);
        indexes = 1:9;
    end
end