clear all;clc;
dirpath = cd;
sessions = dir;
sessions = sessions(3:end);
for isess = 2:length(sessions)
    cd([dirpath,'\',sessions(isess-1).name])
    CellsPrev = load('rezFinal.mat');
    nt0 = CellsPrev.rez.ops.nt0;
    cd([dirpath,'\',sessions(isess).name])
    CellsPost = load('rezFinal.mat');
    
    SimilarityMatrix = zeros(length(unique(CellsPrev.rez.st(:,end))), length(unique(CellsPost.rez.st(:,end))));
    
    for icellprev = 1:length(unique(CellsPrev.rez.st(:,end)))
            as = CellsPrev.rez.M_template(:,:,icellprev);
            as = reshape(as,[],CellsPrev.rez.ops.NchanTOT*nt0);
        for icellpost = 1:length(unique(CellsPost.rez.st(:,end)))
            bs = CellsPost.rez.M_template(:,:,icellpost);
            bs = reshape(bs,[],CellsPost.rez.ops.NchanTOT*nt0);
            score = xcorr(as,bs,0,'coeff');
            SimilarityMatrix(icellprev,icellpost) = score;
        end
    end
    save SimilarityMatrix SimilarityMatrix
end

    
    
    
