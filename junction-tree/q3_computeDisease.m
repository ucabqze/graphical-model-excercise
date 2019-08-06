function q3_computeDisease()

import brml.*
load('data/diseaseNet.mat');

%initialize variables
d = 1:20;
s = 21:60;

%construct junciton tree
[jtpot jtsep infostruct]=jtree(pot);
%Assign known potentials to cliques in a Junction Tree
pot_given_s1to10 = setpot(pot,s(1:10),[1 1 1 1 1 2 2 2 2 2]);
[jtpot jtsep pottoJTclique]=jtassignpot(pot_given_s1to10,infostruct);
%absorption
jtpot=absorption(jtpot,jtsep,infostruct);

for d=1:length(d)
    
    jv_index = whichpot(jtpot,d,1);  % p_d calculated by any clique containing d in Clique Graph is the same
    p_d=sumpot(jtpot(jv_index),d,0); %sum p_d != 1 (because the value assignment for symptoms 1-10), therefor it needs to be normalise 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pd_given_s1to10(d)=p_d.table(1)/sum(p_d.table);%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    disp(['p(d',num2str(d),'=1|s1:10)= ',num2str(pd_given_s1to10(d))]);
end

