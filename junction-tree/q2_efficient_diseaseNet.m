function q2_efficient_diseaseNet()

import brml.*
load('data/diseaseNet.mat');

%initialize variables
d = 1:20;
s = 21:60;


for i = s(1):s(length(s))
    
    %Find parents for symptom i
    parent_index_set = [];
    for x = 1:length(pot{i}.variables)
        if pot{i}.variables(x)~=i
            pa_index = pot{i}.variables(x);
            parent_index_set = [parent_index_set pa_index];
        end
    end
    
    %Calculate p_a
    temp = pot{i}*pot{parent_index_set(1)}*pot{parent_index_set(2)}*pot{parent_index_set(3)};
    p_a(i-(s(1)-1))=sumpot(temp,parent_index_set,1).table(1); % p_a(i)
    
    disp(['P(s',num2str(i-(s(1)-1)),'=1) = ',num2str(p_a(i-(s(1)-1)))]);
    
end