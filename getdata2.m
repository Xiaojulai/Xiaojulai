% ��һ���������ݣ������������޳�
%% ��������
load('F:/ˮ����Ŀ/ˮ����Ŀ/waterpump/loss_file/data/Out_waterandstress.mat')  
load('F:/ˮ����Ŀ/ˮ����Ŀ/waterpump/loss_file/data/In_waterandstress.mat')  
tmp=(1:3600);
%% ��������վ��������ѹ�����ݺϲ�
% ѹ����ƽ��ֵ
Out_stress=mean([Out_waterandstress(:,1)';Out_waterandstress(:,2)'])';
Out_water=sum([Out_waterandstress(:,3)';Out_waterandstress(:,4)'])';
% �������
In_stress=mean([In_waterandstress(:,1)';In_waterandstress(:,2)'])';
In_water=sum([In_waterandstress(:,3)';In_waterandstress(:,4)'])';
% A=[tmp',Out_waterandstress,In_waterandstress];
A=[tmp',Out_waterandstress,In_waterandstress,Out_stress,Out_water,In_stress,In_water];
[m,n]=size(A);
error_num=0; % ͳ��������ݸ���

%% ����Ԥ����
% �������ܵ��������쳣�޳�
for i = 1:m
    if A(i-error_num,6)<=0   % ��ѻ����ˮ��վ1�ܽ���ѹ��Ϊ���������޳�
        A(i-error_num,:)= [];
        error_num=error_num+1; 
    elseif isnan(A(i-error_num,2))  % ���³�ȡˮ��վ1�ܳ���ѹ��ΪNAN�������޳�
        A(i-error_num,:)= [];
        error_num=error_num+1; 
    elseif isnan(A(i-error_num,3))  % ���³�ȡˮ��վ2�ܳ���ѹ��ΪNAN�������޳�
        A(i-error_num,:)= [];
        error_num=error_num+1; 
    elseif isnan(A(i-error_num,6))  % ��ѻ����ˮ��վ1�ܽ���ѹ��ΪNAN�������޳�
        A(i-error_num,:)= [];
        error_num=error_num+1; 
	elseif isnan(A(i-error_num,7))  % ��ѻ����ˮ��վ2�ܽ���ѹ��ΪNAN�������޳�
        A(i-error_num,:)= [];
        error_num=error_num+1; 
    end
end
% ���������ݺϲ�����쳣�����޳�
B=sortrows(A,11);
[m,n]=size(B);
error_num=0;
for i = 2:m
    if sum(B(i-error_num,11)-B(i-error_num,13))<0  % ���³���������ѻ���������Ĳ�ֵС��0
        B(i-error_num,:)=[];
        error_num=error_num+1;
    elseif  abs(B(i-error_num,10)-B(i-error_num-1,10))>=0.03 && B(i-error_num,11)-B(i-error_num-1,11)<2000  % ���³�ǰ��ѹ�������0.03Mpa����������2000m3����
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
save('F:/ˮ����Ŀ/ˮ����Ŀ/waterpump/loss_file/data/end_Out','end_Out');
save('F:/ˮ����Ŀ/ˮ����Ŀ/waterpump/loss_file/data/end_In','end_In');
plot_data;