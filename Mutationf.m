function [NPOP,time]=Mutationf(POP,bu,bd,pm)
%--------------------------------------------------------------------------
tic;
[N,C]=size(POP);
eta_m=20;
NPOP=POP;
for i=1:N
    for j=1:C
        r1=rand;
        if r1<=pm
            y=POP(i,j);
            yd=bd(j);yu=bu(j);
            if y>yd
                if (y-yd)<(yu-y)
                    delta=(y-yd)/(yu-yd);
                else
                    delta=(yu-y)/(yu-yd);
                end
                r2=rand;
                indi=1/(eta_m+1);
                if r2<=0.5
                    xy=1-delta;
                    val=2*r2+(1-2*r2)*(xy^(eta_m+1));
                    deltaq=val^indi-1;
                else
                    xy=1-delta;
                    val=2*(1-r2)+2*(r2-0.5)*(xy^(eta_m+1));
                    deltaq=1-val^indi;
                end
                y=y+deltaq*(yu-yd);
                NPOP(i,j)=min(y,yu);NPOP(i,j)=max(y,yd);
            else
                NPOP(i,j)=rand*(yu-yd)+yd;
            end
        end
    end 
end
time=toc;