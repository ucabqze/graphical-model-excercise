function q1_JT_diseaseNet()

import brml.*
load('data/diseaseNet.mat');

%initialize variables
d = 1:20;
s = 21:60;

%construct junciton tree
[jtpot jtsep infostruct]=jtree(pot);

%absorption
jtpot=absorption(jtpot,jtsep,infostruct); 

%sum to calculate marginals of symptom
for i = s(1):s(length(s))
    %find the junction variable contain the symptom i 
    jv_index = whichpot(jtpot,i); 
    
    %calculate p_a using junction tree
    p_a(i-(s(1)-1))=sumpot(jtpot{jv_index},i,0).table(1); % p_a(i)
    
    disp(['P(s',num2str(i-(s(1)-1)),'=1) = ',num2str(p_a(i-(s(1)-1)))]);
 
end



