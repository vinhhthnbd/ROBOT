function Trajectory_Planning(handles)
%% Lấy giá trị từ GUI
a2 = str2num(get(handles.edit__a2, 'String')); 
a3 = str2num(get(handles.edit__a3, 'String')); 
d = str2num(get(handles.edit__d, 'String'));
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
qf = ((x1 - x2)^2 + (y1 - y2)^2 + (z1 - z2)^2)^(1/2);
set(handles.q_max, 'string', num2str(round(qf,2)));

tb = v_max / a_max;
tf = (qf - v_max * tb) / v_max + 2 * tb;

step = 10;
t = linspace(0, tf, 1000);

% Khởi tạo các vector bên ngoài vòng lặp
time_a = linspace(0, tf, 1000 / step); % Tạo vector thời gian
theta1_g = zeros(1, length(time_a)); % Khởi tạo vector cho theta1
theta2_g = zeros(1, length(time_a)); % Khởi tạo vector cho theta2
theta3_g = zeros(1, length(time_a)); % Khởi tạo vector cho theta3
theta1_dot = zeros(1, length(time_a)); % Khởi tạo theta1_dot
theta2_dot = zeros(1, length(time_a)); % Khởi tạo theta2_dot
theta3_dot = zeros(1, length(time_a)); % Khởi tạo theta3_dot
q_a = zeros(1, length(time_a));
vel_a = zeros(1, length(time_a));
acc_a = zeros(1, length(time_a));

% Bắt đầu vòng lặp
for i = 1:(1000 / step)
    % Tính toán q, v, a tại bước i
    if t(i * step) <= tb
        q = a_max * t(i * step)^2 / 2;
        v = a_max * t(i * step);
        a = a_max;
    elseif t(i * step) <= tf - tb
        q = (qf - v_max * tf) / 2 + v_max * t(i * step);
        v = v_max;
        a = 0;
    elseif t(i * step) <= tf
        q = qf - a_max * (tf - t(i * step))^2 / 2;
        v = a_max * (tf - t(i * step));
        a = -a_max;
    end

    % Lưu giá trị vào các vector
    q_a(i) = q;
    vel_a(i) = v;
    acc_a(i) = a;

    % Tính toán vị trí mục tiêu pWx, pWy, pWz
    lambda = q_a(i) / qf;
    C = A + lambda * (B - A);
    pWx = C(1);
    pWy = C(2);
    pWz = C(3);

    % Inverse Kinematics
    c3 = (pWx^2 + pWy^2 + (pWz - d)^2 - a2^2 - a3^2) / (2 * a2 * a3);
    s3 = sqrt(1 - c3^2);
    theta3 = atan2(s3, c3);
    c2 = (+sqrt(pWx^2 + pWy^2) * (a2 + a3 * c3) + (pWz - d) * a3 * s3) / (a2^2 + a3^2 + 2 * a2 * a3 * c3);
    s2 = (-sqrt(pWx^2 + pWy^2) * a3 * s3 + (pWz - d) * (a2 + a3 * c3)) / (a2^2 + a3^2 + 2 * a2 * a3 * c3);
    theta2 = atan2(s2, c2);
    theta1 = atan2(pWy, pWx);

    % Lưu giá trị vào các vector góc
    theta1_g(i) = theta1;
    theta2_g(i) = theta2;
    theta3_g(i) = theta3;
    if i > 1
       theta1_dot(i) = (theta1_g(i) - theta1_g(i-1)) / (time_a(i) - time_a(i-1)); 
       theta2_dot(i) = (theta2_g(i) - theta2_g(i-1)) / (time_a(i) - time_a(i-1));  
       theta3_dot(i) = (theta3_g(i) - theta3_g(i-1)) / (time_a(i) - time_a(i-1)); 
    end
    %% DH Table và Forward Kinematics
    a = [0; a2; a3];
    alpha = [pi/2; 0; 0];
    d1 = [d; 0; 0];
    theta = [theta1; theta2; theta3];

    % Tính toán ma trận chuyển động
    A0_1 = DH(a(1), alpha(1), d1(1), theta(1));
    A1_2 = DH(a(2), alpha(2), d1(2), theta(2));
    A2_3 = DH(a(3), alpha(3), d1(3), theta(3));
    A0_0 = [1 0 0; 0 1 0; 0 0 1];
    
    A0_2 = A0_1 * A1_2;
    A0_3 = A0_1 * A1_2 * A2_3;

    % Tính toán vị trí các điểm
    p0 = [0; 0; 0];
    [p1, o1] = cal_pose(A0_1, p0);
    [p2, o2] = cal_pose(A0_2, p0);
    [p3, o3] = cal_pose(A0_3, p0);

    % Vẽ các điểm và liên kết
    p_robot = [p1 p2 p3]';
    axes(handles.axes1);
    cla;
    hold on;
    grid on;
    axis equal;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title('Robot Articulated Arm - 3DOF');

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
    plot3(handles.axes1,[x1 pWx],[y1 pWy],[z1 pWz],'b','lineWidth',1);
    % Cập nhật giá trị vào các ô trong GUI
    set(handles.edit_theta1, 'string', num2str(theta1 * 180 / pi));
    set(handles.edit_theta2, 'string', num2str(theta2 * 180 / pi));
    set(handles.edit_theta3, 'string', num2str(theta3 * 180 / pi));

    %%
    VeHinhTru(handles,0,0,0,0.3,0.05,[69, 170, 120]/255);
    % Vẽ các liên kết giữa các khớp
    plot3([p0(1) p1(1)], [p0(2) p1(2)], [p0(3) p1(3)], 'r-', 'LineWidth', 8);
    plot3([p1(1) p2(1)], [p1(2) p2(2)], [p1(3) p2(3)], 'g-', 'LineWidth', 8);
    plot3([p2(1) p3(1)], [p2(2) p3(2)], [p2(3) p3(3)], 'b-', 'LineWidth', 8);
    plot3(p1(1), p1(2), p1(3), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    plot3(p2(1), p2(2), p2(3), 'go', 'MarkerSize', 8, 'MarkerFaceColor', 'g');
    plot3(p3(1), p3(2), p3(3), 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
    drawJoint(handles.axes1,theta1, p1(1), p1(2), p1(3), 0.15, 0.4, [0/255, 40/255, 50/255]) ;
    drawJoint(handles.axes1,theta1, p2(1), p2(2), p2(3), 0.15, 0.4, [0/255, 40/255, 50/255]) ;
    drawJoint(handles.axes1,theta1, p3(1), p3(2), p3(3), 0.15, 0.25, [0/255, 40/255, 50/255]) ;
    xlim([-3 3]);
    ylim([-3 3]);
    zlim([-2 3]);
    hold off;
    rotate3d(handles.axes1, 'on');
    %%
    cla(handles.theta2,'reset');
    hold(handles.theta2,'on');
    grid(handles.theta2,'on');

    cla(handles.q,'reset');
    grid(handles.q, 'on');
    hold(handles.q,'on');
    %
    cla(handles.v,'reset');
    grid(handles.v, 'on');
    hold(handles.v,'on');
    %
    cla(handles.a,'reset');
    hold(handles.a, 'on');
    grid(handles.a, 'on');
    %
    cla(handles.theta1,'reset');
    grid(handles.theta1, 'on');
    hold(handles.theta1,'on');
    %
    cla(handles.theta3,'reset');
    grid(handles.theta3, 'on');
    hold(handles.theta3,'on');

    cla(handles.theta1_dot,'reset');
    grid(handles.theta1_dot, 'on');
    hold(handles.theta1_dot,'on');

    cla(handles.theta2_dot,'reset');
    grid(handles.theta2_dot, 'on');
    hold(handles.theta2_dot,'on');

    cla(handles.theta3_dot,'reset');
    grid(handles.theta3_dot, 'on');
    hold(handles.theta3_dot,'on');
    %%
    xlabel(handles.a,'time');
    ylabel(handles.a,'acceleration');
    plot(handles.a,time_a,acc_a,'lineWidth',0.5);

    xlabel(handles.q,'time');
    ylabel(handles.q,'Q');
    plot(handles.q,time_a,q_a,'lineWidth',0.5);

    xlabel(handles.v,'time');
    ylabel(handles.v,'velocity');
    plot(handles.v,time_a,vel_a,'lineWidth',0.5);

    xlabel(handles.theta1,'time');
    ylabel(handles.theta1,'theta1');
    plot(handles.theta1,time_a,theta1_g * 180/pi,'lineWidth',0.5);

    xlabel(handles.theta1_dot,'time');
    ylabel(handles.theta1_dot,'theta1_ dot');
    plot(handles.theta1_dot,time_a,theta1_dot* 180/pi,'lineWidth',0.5);

    
    xlabel(handles.theta2,'time');
    ylabel(handles.theta2,'theta2');
    plot(handles.theta2,time_a,theta2_g * 180/pi,'lineWidth',0.5);

    xlabel(handles.theta2_dot,'time');
    ylabel(handles.theta2_dot,'theta2_ dot');
    plot(handles.theta2_dot,time_a,theta2_dot* 180/pi,'lineWidth',0.5);

    xlabel(handles.theta3_dot,'time');
    ylabel(handles.theta3_dot,'theta3_ dot');
    plot(handles.theta3_dot,time_a,theta3_dot* 180/pi,'lineWidth',0.5);

    xlabel(handles.theta3,'time');
    ylabel(handles.theta3,'theta3');
    plot(handles.theta3,time_a,theta3_g * 180/pi,'lineWidth',0.5);

end
% cla(handles.a,'reset');
% hold(handles.a, 'on');
% grid(handles.a, 'on');
% set(handles.a,'visible','on');
%     xlabel(handles.a,'time');
%     ylabel(handles.a,'acceleration');
%     plot(handles.a,time_a,acc_a,'lineWidth',1);
% Vẽ đồ thị cho các góc theta1, theta2, theta3
% figure;
% subplot(3, 1, 1);
% plot(time_a, acc_a, 'r', 'LineWidth', 0.5);
% xlabel('Time');
% ylabel('acc');
% grid on;
% 
% subplot(3, 1, 2);
% plot(time_a, theta2_g * 180 / pi, 'g', 'LineWidth', 0.5);
% xlabel('Time');
% ylabel('Theta2 (degrees)');
% grid on;
% 
% subplot(3, 1, 3);
% plot(time_a, theta3_g * 180 / pi, 'b', 'LineWidth', 0.5);
% xlabel('Time');
% ylabel('Theta3 (degrees)');
% grid on;
% 
%         figure;  % Mở một cửa sổ đồ thị mới
%         subplot(3, 1, 1);  % Vẽ theta1_dot
%         plot(time_a, theta1_dot, 'r', 'LineWidth', 2);
%         title('Theta1 Dot (Tốc độ góc của Joint 1)');
%         xlabel('Thời gian (s)');
%         ylabel('Tốc độ góc (rad/s)');
%         grid on;
end
