function tess(handles)
cla(handles.q,'reset');
set(handles.q,'visible','on');
%
cla(handles.v,'reset');
set(handles.v,'visible','on');
%
cla(handles.a,'reset');
hold(handles.a, 'on');
grid(handles.a, 'on');
set(handles.a,'visible','on');
%% Lấy giá trị từ GUI
a2 = str2num(get(handles.edit__a2, 'String')); 
a3 = str2num(get(handles.edit__a3, 'String')); 
d = str2num(get(handles.edit__d, 'String'));
% theta1 = str2num(get(handles.edit_theta1,'String'))*pi/180;
% theta2 = str2num(get(handles.edit_theta2,'String'))*pi/180;
% theta3 = str2num(get(handles.edit_theta3,'String'))*pi/180;
v_max     = str2num(get(handles.v_max,'String'));
a_max     = str2num(get(handles.a_max,'String'));
%% Old_Position
x1     = str2num(get(handles.px1,'String'));
y1     = str2num(get(handles.py1,'String'));
z1     = str2num(get(handles.pz1,'String'));
%% New_Position
x2     = str2num(get(handles.px2,'String'));
y2     = str2num(get(handles.py2,'String'));
z2     = str2num(get(handles.pz2,'String'));
%% đường thẳng AB
A = [x1, y1, z1];  % Tọa độ điểm A
B = [x2, y2, z2];  % Tọa độ điểm B
%% qmax
% cal distance
qf = ((x1 - x2)^2+(y1 - y2)^2+(z1 - z2)^2)^(1/2);
set(handles.q_max, 'string', num2str(round(qf,2)));
% v_max=10;
% a_max=5;
%qf=80;

tb = v_max/a_max;

    tf = (qf - v_max*tb)/(v_max) + 2*tb;

%     t       = 0:0.1:tf;
%     lengthT = length(t);
%     q = zeros(lengthT,1);
%     v = zeros(lengthT,1);
%     a = zeros(lengthT,1);
%%
step = 10;
num_steps = 1000 / step;  % Số bước tính toán
% t       = 0:0.01:tf;
% lengthT = length(t);
% Khởi tạo lại các vector q, v, a với số phần tử phù hợp
t = linspace(0, tf, num_steps);  % Tạo vector thời gian với num_steps phần tử
q = zeros(num_steps, 1);
v = zeros(num_steps, 1);
a = zeros(num_steps, 1);
px_a = zeros(1, num_steps);
py_a = zeros(1, num_steps);
pz_a = zeros(1, num_steps);
    %%
  for i = 1:num_steps
    % Cập nhật giá trị thời gian t
    t_current = t(i);

    if t_current <= tb
        q(i) = a_max * t_current^2 / 2;
        v(i) = a_max * t_current;
        a(i) = a_max;
    elseif t_current <= tf - tb
        q(i) = (qf - v_max * tf) / 2 + v_max * t_current;
        v(i) = v_max;
        a(i) = 0;
    elseif t_current <= tf
        q(i) = qf - a_max * (tf - t_current)^2 / 2;
        v(i) = a_max * (tf - t_current);
        a(i) = -a_max;
    end
      %%
% cla(handles.q,'reset');
% hold(handles.q,'on');
% grid(handles.q,'on');
% %
% cla(handles.v,'reset');
% hold(handles.v,'on');
% grid(handles.v,'on');
% %
% cla(handles.a,'reset');
% hold(handles.a,'on');
% grid(handles.a,'on');
%% q
xlabel(handles.q,'time');
ylabel(handles.q,'position');
plot(handles.q,t,q,'lineWidth',0.5);
%% v
xlabel(handles.v,'time');
ylabel(handles.v,'velocity');
plot(handles.v,t,v,'lineWidth',0.5);
%% a
xlabel(handles.theta1,'time');
ylabel(handles.theta1,'acc');
plot(handles.theta1,t,a,'lineWidth',0.5);

%%
step=1000;
for b=1:(1000/step)
lambda = q(i) / qf;
C = A + lambda * (B - A);
x3 = C(1);
y3 = C(2);
z3 = C(3);
%%

%% Animation
x_a=linspace(x1,x3,1000);
y_a=linspace(y1,y3,1000);
z_a=linspace(z1,z3,1000);
%%
% step=1000;
% for b=1:(1000/step)
   pWx=x_a(b*step);
   pWy=y_a(b*step);
   pWz=z_a(b*step);
%    pWx=x_a(i);
%    pWy=y_a(i);
%    pWz=z_a(i);
%% Inverse_Kinematic
c3 = (pWx^2 + pWy^2 + (pWz - d)^2 - a2^2 - a3^2) / (2 * a2 * a3);
s3 = sqrt(1 - c3^2);
theta3 = atan2(s3, c3);
c2 = (+sqrt(pWx^2 + pWy^2) * (a2 + a3*c3) + (pWz - d) * a3 * s3) / (a2^2 + a3^2 + 2*a2*a3*c3);
s2 = (-sqrt(pWx^2 + pWy^2) * a3 * s3 + (pWz - d) * (a2 + a3*c3)) / (a2^2 + a3^2 + 2*a2*a3*c3);
theta2= atan2(s2, c2);
theta1 = atan2(pWy, pWx);
%% DH_Table
a     = [0    ; a2     ;  a3     ];
alpha = [pi/2 ; 0      ;  0      ];
d1     = [d    ; 0      ;  0      ]; 
theta = [theta1;theta2 ;  theta3 ];
%% Forward_Kinematic
A0_1 = DH(a(1),alpha(1),d1(1),theta(1)) ;
A1_2 = DH(a(2),alpha(2),d1(2),theta(2)) ;
A2_3 = DH(a(3),alpha(3),d1(3),theta(3)) ;
A0_0=[1 0 0 ; 0 1 0 ; 0 0 1 ];
%T1 = A0_1;
A0_2 = A0_1 * A1_2;
A0_3 = A0_1 * A1_2 * A2_3;
p0 = [0;0;0];
pc = [0;0;0]';
[p1, o1] = cal_pose(A0_1,p0);
[p2, o2] = cal_pose(A0_2,p0);
[p3, o3] = cal_pose(A0_3,p0);
p_robot = [p1 p2 p3]';
%%
px_a(b)=p3(1);
py_a(b)=p3(2);
pz_a(b)=p3(3);
%% Update_Data

    axes(handles.axes1);
    cla;  % Xóa nội dung trước đó trên axes
    hold on;
    grid on;
    axis equal;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title('Robot Articulated Arm - 3DOF');

    %VeHop(handles,0,0,0,0.6,0.6,0.15,[65, 170, 196]/255)
    VeHinhTru(handles,0,0,0,0.8,0.05,[69, 170, 120]/255);
    % Gán giá trị vào các ô trong GUI
    set(handles.edit_theta1, 'string', num2str(theta1*180/pi));
    set(handles.edit_theta2, 'string', num2str(theta2*180/pi));
    set(handles.edit_theta3, 'string', num2str(theta3*180/pi));
    %%
%     theta1_g(i*step)=theta1;
%     xlabel(handles.a,'time');
%     ylabel(handles.a,'position');
%     plot(handles.a,t,theta1_g,'lineWidth',0.5);
    %%
    if handles.checkbox_coordinate_0.Value
    plot_coordinate(0,0,0,A0_0,'0');
    end
    if handles.checkbox_coordinate_1.Value
    plot_coordinate(p_robot(1,1),p_robot(1,2),p_robot(1,3),A0_1,'1');
    end
    if handles.checkbox_coordinate_2.Value
    plot_coordinate(p_robot(2,1),p_robot(2,2),p_robot(2,3),A0_2,'2');
    end
    if handles.checkbox_coordinate_3.Value
    plot_coordinate(p_robot(3,1),p_robot(3,2),p_robot(3,3),A0_3,'3');    
    end
%     if handles.checkbox_trajectory.Value
    %plot3(handles.axes1,px_a,py_a,pz_a,'r','lineWidth',1);
    plot3(handles.axes1,[x1 x3],[y1 y3],[z1 z3],'b','lineWidth',1);
%     end
%

    % Vẽ các liên kết giữa các khớp
    % plot_base(handles);
    plot3([p0(1) p1(1)], [p0(2) p1(2)], [p0(3) p1(3)], 'r-', 'LineWidth', 5); % Liên kết 1
    plot3([p1(1) p2(1)], [p1(2) p2(2)], [p1(3) p2(3)], 'g-', 'LineWidth', 5); % Liên kết 2
    plot3([p2(1) p3(1)], [p2(2) p3(2)], [p2(3) p3(3)], 'b-', 'LineWidth', 5); % Liên kết 3
    % Vẽ các điểm khớp
    %plot3(p0(1), p0(2), p0(3), 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k'); % Gốc
    plot3(p1(1), p1(2), p1(3), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); % Khớp 1
    plot3(p2(1), p2(2), p2(3), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g'); % Khớp 2
    plot3(p3(1), p3(2), p3(3), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b'); % Đầu cuối
    
    xlim([-3 3]); ylim([-3 3]); zlim([0 3]);
    hold off;
    rotate3d(handles.axes1, 'on');


end

   end
% 
% xlabel(handles.a,'time');
% ylabel(handles.a,'acc');
% plot(handles.a,t,a,'lineWidth',0.5);
end