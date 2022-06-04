function f=Harmonic_crowding_distance(ClonePOP,Clonepa)

n=size(ClonePOP,1);
for i=1:n
    ClonePOP1=ClonePOP;
    ClonePOP1(i,:)=[];
    for j=1:n-1
        cd(j)=1/norm(ClonePOP(i,:)-ClonePOP1(j,:));
    end
    CD(i)=1/sum(cd);
end
[dis rows2222]=sort(CD,2,'descend');
ClonePOP2222=ClonePOP(rows2222,:);
Clonepa2222=Clonepa(rows2222,:);
f=[ClonePOP2222 Clonepa2222];


