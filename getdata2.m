% 进一步处理数据，将离异数据剔除
%% 导入数据
load('F:/水泵项目/水泵项目/waterpump/loss_file/data/Out_waterandstress.mat')  
load('F:/水泵项目/水泵项目/waterpump/loss_file/data/In_waterandstress.mat')  
tmp=(1:3600);
%% 将两个泵站的流量、压力数据合并
% 压力求平均值
Out_stress=mean([Out_waterandstress(:,1)';Out_waterandstress(:,2)'])';
Out_water=sum([Out_waterandstress(:,3)';Out_waterandstress(:,4)'])';
% 流量求和
In_stress=mean([In_waterandstress(:,1)';In_waterandstress(:,2)'])';
In_water=sum([In_waterandstress(:,3)';In_waterandstress(:,4)'])';
% A=[tmp',Out_waterandstress,In_waterandstress];
A=[tmp',Out_waterandstress,In_waterandstress,Out_stress,Out_water,In_stress,In_water];
[m,n]=size(A);
error_num=0; % 统计误差数据个数

%% 数据预处理
% 将单个管道的数据异常剔除
for i = 1:m
    if A(i-error_num,6)<=0   % 将鸦岗配水泵站1管进口压力为负的数据剔除
        A(i-error_num,:)= [];
        error_num=error_num+1; 
    elseif isnan(A(i-error_num,2))  % 将下陈取水泵站1管出口压力为NAN的数据剔除
        A(i-error_num,:)= [];
        error_num=error_num+1; 
    elseif isnan(A(i-error_num,3))  % 将下陈取水泵站2管出口压力为NAN的数据剔除
        A(i-error_num,:)= [];
        error_num=error_num+1; 
    elseif isnan(A(i-error_num,6))  % 将鸦岗配水泵站1管进口压力为NAN的数据剔除
        A(i-error_num,:)= [];
        error_num=error_num+1; 
	elseif isnan(A(i-error_num,7))  % 将鸦岗配水泵站2管进口压力为NAN的数据剔除
        A(i-error_num,:)= [];
        error_num=error_num+1; 
    end
end
% 将两管数据合并后的异常数据剔除
B=sortrows(A,11);
[m,n]=size(B);
error_num=0;
for i = 2:m
    if sum(B(i-error_num,11)-B(i-error_num,13))<0  % 当下陈总流量与鸦岗总流量的差值小于0
        B(i-error_num,:)=[];
        error_num=error_num+1;
    elseif  abs(B(i-error_num,10)-B(i-error_num-1,10))>=0.03 && B(i-error_num,11)-B(i-error_num-1,11)<2000  % 当下陈前后压力差大于0.03Mpa且流量差在2000m3以内
        B(i-error_num,:)=[];
        error_num=error_num+1;
    elseif  abs(B(i-error_num,10)-B(i-error_num-1,10))>=0.02 && abs(B(i-error_num-1,10)-B(i-error_num+1,10))<0.01
        B(i-error_num,:)=[]; 
        error_num=error_num+1;
    end
end

end_data=sortrows(B,1);
end_Out=end_data(:,10:11);
end_In=end_data(:,12:13);
save('F:/水泵项目/水泵项目/waterpump/loss_file/data/end_Out','end_Out');
save('F:/水泵项目/水泵项目/waterpump/loss_file/data/end_In','end_In');
plot_data;