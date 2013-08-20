clear,clc
cd C:\Users\wjh\Documents\百度云\iMake\竞赛\数模\cumcm2009B
num=[55 72 82 39 101];
load('out.mat');
load('chart.mat');
load('wait.mat');
%load('level.mat');
load('time2.mat');

level=[
     1     1     1     1     1     1     1
     2     2     4     4     5     3     3
     5     5     5     5     3     2     2
     3     3     2     2     4     4     4
     4     4     3     3     2     5     5
     ];

%day
n=2000;
block=zeros(n+100,1);

catn=79;
for i=1:79
    ty=chart(i,1);
    outtime=out(ty,randi(num(ty)));
    chart(i,5)=outtime+chart(i,4);
    block(chart(i,5))=block(chart(i,5))+1;
end

lambda=[1.018	1.6	2.216	1.054	2.703];
prd=zeros(n,5);

for i=1:5
    prd(:,i)=poissrnd(lambda(i),n,1);
end

tt=0;
m=0;
u=0; %空床数
for day=73:n
    
    weekday=mod(1+day,7)+1; 
    %上床
    u=u+block(day);
    %chart=[chart;NaN NaN NaN NaN NaN];
    %catn=catn+1;
    for lv=1:5
        ty=find(level(:,weekday)==lv);
        can1=((wait(:,1)==ty) & (wait(:,2)<day));
        m=min(u,sum(can1));
        if m>0
            can=find(can1);
            opertime=time2(ty,weekday)+day;
            outtime=out(ty,randi(num(ty),1,m))'+opertime;
            for i=1:m 
                block(outtime(i))=block(outtime(i))+1;
            end
            chart(catn+1:catn+m,:)=[wait(can(1:m),:) ones(m,1)*[day opertime] outtime];
            catn=catn+m;
            wait(can(1:m),:)=[];
            u=u-m;
        end
        
        if u<1 break; end
    end
    %排队+
    add=[];
    for ty=1:5
        for j=1:prd(day,ty)
            add=[add;ty day];
        end
    end
    %tt=tt+size(add,1);
    wait=[wait;add];
    tt=tt+size(wait,1);
end






