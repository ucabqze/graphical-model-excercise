function logz = computeNormalisationConstant()

import brml.*

%p1= array([1 2], [1 2;3 4])
%p2= array([3 4],[0.05 0.3; 0.45 0.2])

%Create a lattice
N = 10;
lattice_index =1:N*N;

%x is a binary variable, calculate the potential value for phi
for xi = 0:1
    for xj = 0:1
        phi_table(xi+1,xj+1)=exp(double(xi==xj));
    end
end

%Calculate phi
for i = 1:size(lattice_index,2) 
    for j = 1:size(lattice_index,2)
        if i-j == 1
            phi_row{j} = array([i j],phi_table); %it represent phi(j,j+1) 10*9
            if mod(j,10)==0
               phi_row{j} = NaN;
            end
        elseif i-j == 10 
           phi_col{j} = array([i j],phi_table); %it represent phi(j,j+10) 9*10
        end
    end
end

%Stack 
for a=1:N-1 %column index
    for b = 0:N-2 %row index 
        if b==0
            phi_col_stack{a} = phi_col{a}*phi_row{a};
        else
            phi_col_stack{a} = phi_col_stack{a}*phi_col{a+b*N};
            phi_col_stack{a} = phi_col_stack{a}*phi_row{a+b*N}; 
            %disp(a+b*N);
        end
    end
end 
%the last column
for b = 1-1:N-1-1
    phi_col_stack{N-1} = phi_col_stack{N-1}*phi_col{N-1+b*N};
end
%the last row
for a = 1:N-1
    phi_col_stack{a} = phi_col_stack{a}*phi_row{a+(N-1)*N};
end 

%masseage pass to calculate Z
for i = 1:N
    xi = [];
    if i~=N
        for j = 1:length(phi_col_stack{i}.variables)
        
            if mod(j,2)==1
                xi= [xi phi_col_stack{i}.variables(j)];
            end
        end
    end
    
    if i == N
        for j = 1:length(phi_col_stack{i-1}.variables)
            if mod(j,2)==0
                xi= [xi phi_col_stack{i-1}.variables(j)];
            end
        end
    end
    
    if i == 1
        x = xi;
    else
        x = [x;xi];
    end 
    
end

z = sumpot(phi_col_stack{N-1}, x(N,:));
for k=N-2:-1:2
    z = sumpot(z*phi_col_stack{k}, x(k+1,:));
end
z= sumpot(z*phi_col_stack{1},[],0);
logz = log(z.table);
disp(logz);
