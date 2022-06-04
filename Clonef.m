function  [NPOP,time]=Clonef(POP,pa,CS) 
%--------------------------------------------------------------------------
tic
NC=[];
[N,C]=size(POP);
[POP,pa,padis]=CDAf(POP,pa);
aa=find(padis==inf);
bb=find(padis~=inf);
if length(bb)>0
    padis(aa)=2*max(max(padis(bb)));
    if sum(padis)==0%%%%加写三行，避免下面NC出现无意义的数
        padis=padis+0.001;
    end
    NC=ceil(CS*padis./sum(padis));
else
    NC=ceil(CS/length(aa))+zeros(1,N);
end
NPOP=[];
for i=1:N
    NiPOP=ones(NC(i),1)*POP(i,:);
    NPOP=[NPOP;NiPOP];
end
time=toc;