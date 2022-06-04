function C1=CheckBound(C,Cmax,Cmin)
%  确保C不越界
[m,n]=size(C);

for i=1:m
    for j=1:n
        if C(i,j)>Cmax(j)
            C1(i,j)=rand*(Cmax(j)-Cmin(j))+Cmin(j);
        elseif C(i,j)<Cmin(j)
            C1(i,j)=rand*(Cmax(j)-Cmin(j))+Cmin(j);
        else
             C1(i,j)= C(i,j);
        end
    end
end