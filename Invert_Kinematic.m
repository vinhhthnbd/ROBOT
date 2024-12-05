function T = Invert_Kinematic(handles)
%% Lấy giá trị từ GUI
a2 = str2num(get(handles.edit__a2, 'String')); 
a3 = str2num(get(handles.edit__a3, 'String')); 
d = str2num(get(handles.edit__d, 'String'));
pWx = str2num(get(handles.edit_px, 'String')); 
pWy = str2num(get(handles.edit_py, 'String')); 
pWz = str2num(get(handles.edit_pz, 'String'));
theta1 = str2num(get(handles.edit_theta1,'String'))*pi/180;
theta2 = str2num(get(handles.edit_theta2,'String'))*pi/180;
theta3 = str2num(get(handles.edit_theta3,'String'))*pi/180;
% Tính toán khoảng cách từ điểm tới gốc (end-effector position)
distance = sqrt(pWx^2 + pWy^2 + (pWz-d)^2);

% Kiểm tra điều kiện
if distance < abs(a2 - a3) || distance > (a2 + a3)
    error('Invalid input: Distance does not satisfy the condition |a2 - a3| <= distance <= a2 + a3');
end

% Tính toán c3 và kiểm tra
c3 = (pWx^2 + pWy^2 + (pWz - d)^2 - a2^2 - a3^2) / (2 * a2 * a3);
if abs(c3) > 1
    error('Invalid value for c3: abs(c3) exceeds 1. Check your inputs.');
end
s3 = sqrt(1 - c3^2);
theta3_new = atan2(s3, c3);

% Tính toán c2, s2 và kiểm tra
c2 = (+sqrt(pWx^2 + pWy^2) * (a2 + a3*c3) + (pWz - d) * a3 * s3) / (a2^2 + a3^2 + 2*a2*a3*c3);
s2 = (-sqrt(pWx^2 + pWy^2) * a3 * s3 + (pWz - d) * (a2 + a3*c3)) / (a2^2 + a3^2 + 2*a2*a3*c3);
if ~isreal(c2) || ~isreal(s2)
    error('Invalid values for c2 or s2: Inputs to atan2 must be real.');
end
theta2_new = atan2(s2, c2);

% Tính toán theta1
theta1_new = atan2(pWy, pWx);


theta1_a=linspace(theta1,theta1_new,1000); %from theta1 2 theta_set divide for 1000 points
theta2_a=linspace(theta2,theta2_new,1000);
theta3_a=linspace(theta3,theta3_new,1000);
step=15;
for i=1:(1000/step-1)
theta1= theta1_a(i*step);
theta2= theta2_a(i*step);
theta3= theta3_a(i*step);
%% DH_Table
a     = [0    ; a2     ;  a3     ];
alpha = [pi/2 ; 0      ;  0      ];
d1     = [d    ; 0      ;  0      ]; 
theta = [theta1;theta2 ;  theta3 ];
%% HOMOGENEOUS_TRANSFORMATION_between_successive_DH_frames
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
o_robot = [o1; o2; o3];
line1=[[p0(1) p1(1)];[p0(2) p1(2)];[p0(3) p1(3)]];
line2=[[p1(1) p2(1)];[p1(2) p2(2)];[p1(3) p2(3)]];
line3=[[p2(1) p3(1)];[p2(2) p3(2)];[p2(3) p3(3)]];
axes(handles.axes1);
    cla;  % Xóa nội dung trước đó trên axes
    hold on;
    grid on;
    axis equal;
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title('Robot Articulated Arm - 3DOF');

    %VeHop(handles,0,0,0,0.6,0.6,0.15,[65, 170, 196]/255)
    VeHinhTru(handles,0,0,0,0.3,0.05,[69, 170, 120]/255);
    % Gán giá trị vào các ô trong GUI
set(handles.edit_theta1, 'string', num2str(theta1*180/pi));
set(handles.edit_theta2, 'string', num2str(theta2*180/pi));
set(handles.edit_theta3, 'string', num2str(theta3*180/pi));

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
%     if handles.checkbox_fill.Value
%     PlotWorkspace(handles);
%     end
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
    
    xlim([-3 3]); ylim([-3 3]); zlim([-1 3]);
    hold off;
    rotate3d(handles.axes1, 'on');

end
end
