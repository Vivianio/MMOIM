function Frontshow2(Epa)
%--------------------------------------------------------------------------
if size(Epa,2)==2
    %%plot pareto fronts in 2-D
    f1=Epa(:,1);f2=Epa(:,2);
    plot(f1,f2,'r*'); 
    title('pf');
    xlabel('x1');
    ylabel('x2');
%     grid on;
%     xlabel('Function 1');
%     ylabel('Function 2');
%     hold on   
drawnow
elseif size(Epa,2)>=3
    %%plot pareto fronts in 3-D
    f1=Epa(:,1);f2=Epa(:,2);f3=Epa(:,3);
    plot3(f1,f2,f3,'r*'); 
%     grid on;
    title('pf');
    xlabel('f1');
    ylabel('f2');
    zlabel('f3');
%     hold on   
drawnow
end
