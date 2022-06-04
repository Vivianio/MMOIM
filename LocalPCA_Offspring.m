function [cloneover2]=LocalPCA_Offspring(Model,c,n_obj,CS)
   % Reproduction
    OffspringDec = zeros(CS,c);
    % Generate new trial solutions one by one
    for i = 1 : CS
        % Select one cluster by Roulette-wheel selection
   %         k = find(rand<=probability,1);
        % Generate one offspring
        if ~isempty(Model.eVector)
            lower = Model.a - 0.25*(Model.b-Model.a);
            upper = Model.b + 0.25*(Model.b-Model.a);
            trial = rand(1,n_obj-1).*(upper-lower) + lower;
            sigma = sum(abs(Model.eValue(n_obj:c)))/(c-n_obj+1);
            OffspringDec(i,:) = Model.mean + trial*Model.eVector(:,1:n_obj-1)' + randn(1,c)*sqrt(sigma);
        else
            OffspringDec(i,:) = Model.mean + randn(1,c);
        end
    end
   cloneover2=OffspringDec;