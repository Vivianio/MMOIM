function [MEPOP,MEpa]=MMOIM(testfunction,gmax,Max_FES,bd,bu,Particle_Number,n_obj)
%------------------------------------------------------------------------
CS=10;
number_of_clusters_K =ceil(Particle_Number/CS);

c=size(bu,2);                    %维度
pm=1/c;                          %变异概率

if bu==bd return;end
%-------------------------------------------------------------------------
POP=rand(Particle_Number,c).*(ones(Particle_Number,1)*bu-ones(Particle_Number,1)*bd)+ones(Particle_Number,1)*bd;%初始种群
pa=[];
for i=1:size(POP,1)
    pa(i,:)=feval(testfunction,POP(i,:));%计算适应度
end
fitcount=size(POP,1);
it=0;
IDx=kmeans(POP,number_of_clusters_K);
for i=1:number_of_clusters_K
    rowind=[];
    rowind=find(IDx==i);
    subpopulation{i,1}=[POP(rowind,:) pa(rowind,:)];
end

while it<gmax 
    %每个子种群中发生免疫过程
      for k=1:size(subpopulation,1)
            ClonePOP=[];
            ClonePOP=subpopulation{k,1}(:,1:c);
            Clonepa=[];
            Clonepa=subpopulation{k,1}(:,c+1:c+n_obj); 
            cloneover=[];
            if size(Clonepa,1)<CS
                 [cloneover,Clonet]=Clonef(ClonePOP,Clonepa,CS);%克隆 
              else 
                  f=Harmonic_crowding_distance(ClonePOP,Clonepa);
                  cloneover= f(1:CS,1:c);
            end
            [cloneover,PNmt]=Mutationf(cloneover,bu,bd,pm);%变异，变异个体离自己的个体都比较近
            cloneover=CheckBound(cloneover,bu,bd);
            cloneover=unique(cloneover,'rows');
            clonepa=[];
            for i=1:size(cloneover,1)
                clonepa(i,:)=feval(testfunction,cloneover(i,:));%计算适应度
                fitcount=fitcount+1;
            end
            subPOP=[ClonePOP,Clonepa;cloneover,clonepa];
            subpopulation{k,1}=subPOP;%把原个体与克隆变异过的个体都保留
      end
      
      %%%计算每个子种群的中心
        num_subpop=size(subpopulation,1);
        SUBPOPcenter=zeros(num_subpop,c);
        for k=1:size(subpopulation,1)
            subPOP=[];subPOPcenter1=[];
            subPOP=subpopulation{k,1}(:,1:c);
            subPOPcenter1=(max(subPOP,[],1)+min(subPOP,[],1))/2;
            SUBPOPcenter(k,:)=subPOPcenter1;
        end
           
%       %%最近的两个子种群与其一起建模%%%%%%
      for k=1:size(subpopulation,1)
            clustering_distance=pdist2(SUBPOPcenter(k,1:c),SUBPOPcenter(:,1:c));
            [Dis IDX]=sort(clustering_distance);
            L1=IDX(2);L2=IDX(3);
            ClonePOP=[];
            ClonePOP=subpopulation{k,1}(:,1:c);
            Clonepa=[];
            Clonepa=subpopulation{k,1}(:,c+1:c+n_obj); 
            cloneover=[];
            subPOP_L1=subpopulation{L1,1};
            subPOP_L2=subpopulation{L2,1};
            [Model,probability] = LocalPCA([ClonePOP;subPOP_L1(:,1:c);subPOP_L2(:,1:c)],n_obj);%三个子种群的个体放在一起建模
            [cloneover]=LocalPCA_Offspring(Model,c,n_obj,CS);
            cloneover=CheckBound(cloneover,bu,bd);
            cloneover=unique(cloneover,'rows');
            clonepa=[];
            for i=1:size(cloneover,1)
                clonepa(i,:)=feval(testfunction,cloneover(i,:));%计算适应度
                fitcount=fitcount+1;
            end
            subPOP=[ClonePOP,Clonepa;cloneover,clonepa];
            subpopulation{k,1}=subPOP;
      end

%特殊拥挤距离排序，保留部分个体在原子种群中
       MEPOP=[];MEpa=[];
       for k=1:size(subpopulation,1)
           MEPOP=[MEPOP;subpopulation{k,1}(:,1:c)];
           MEpa=[MEpa;subpopulation{k,1}(:,c+1:c+n_obj)];
       end
       aaa=[];
       aaa=[MEPOP,MEpa];
       aaa=unique(aaa,'rows');
       MEPOP=aaa(:,1:c);
       MEpa=aaa(:,c+1:c+n_obj);
       f = non_domination_scd_sort([MEPOP,MEpa], n_obj, c);
       if size(f,1)>(Particle_Number)||size(f,1)==(Particle_Number)
           MEPOP= f(1:Particle_Number,1:c);%
           MEpa=f(1:Particle_Number,c+1:c+n_obj);%只保留一部分比较优的个体
       else
           MEPOP= f(1:end,1:c);%
           MEpa=f(1:end,c+1:c+n_obj);%只保留一部分比较优的个体
       end

%          %重新聚类
           IDx=kmeans(MEPOP,number_of_clusters_K);
            for i=1:number_of_clusters_K
                rowind=[];
                rowind=find(IDx==i);
                subpopulation{i,1}=[MEPOP(rowind,:) MEpa(rowind,:)];
            end
      it=it+1;
%     figure(1)
%     Frontshow2(MEpa);
%     figure(2)
%     Frontshow1(MEPOP);    
    if fitcount>Max_FES
        break;
    end
end

%  排序一
f = non_domination_scd_sort([MEPOP,MEpa], n_obj, c);
MEPOP= f(1:Particle_Number,1:c);
MEpa=f(1:Particle_Number,c+1:c+n_obj);
disp(sprintf(' generation: %d    number of nodominate:  %d',it,size(MEPOP,1)));
% figure(3)
% Frontshow2(MEpa);% plot the Pareto fronts solved by the last run
% figure(4)
% Frontshow1(MEPOP);

end    

