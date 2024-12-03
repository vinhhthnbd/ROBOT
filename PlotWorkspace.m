function PlotWorkspace(handles)
    hold on;
    % Lấy dữ liệu từ GUI
    a2 = str2double(get(handles.edit__a2, 'String'));
    a3 = str2double(get(handles.edit__a3, 'String'));
    d_val = str2double(get(handles.edit__d, 'String'));
    theta1 = str2double(get(handles.edit_theta1, 'String')) * pi / 180;
    theta2 = str2double(get(handles.edit_theta2, 'String')) * pi / 180;
    theta3 = str2double(get(handles.edit_theta3, 'String')) * pi / 180;

    % Kiểm tra dữ liệu hợp lệ
    if isnan(a2) || isnan(a3) || isnan(d_val) || ...
       isnan(theta1) || isnan(theta2) || isnan(theta3)
        error('Please enter valid numerical values.');
    end

    % DH Table
    a = [0; a2; a3];
    alpha = [pi/2; 0; 0];
    d = [d_val; 0; 0];
    theta = [theta1; theta2; theta3];
    %% HOMOGENEOUS_TRANSFORMATION_between_successive_DH_frames
A0_1 = DH(a(1),alpha(1),d(1),theta(1)) ;
A1_2 = DH(a(2),alpha(2),d(2),theta(2)) ;
A2_3 = DH(a(3),alpha(3),d(3),theta(3)) ;
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
    % Giới hạn góc quay
    theta1_m = 180 * pi / 180;
    theta2_m = 150 * pi / 180;
    theta1 = linspace(-theta1_m, theta1_m, 181);

    % Vẽ các mặt tròn biểu diễn workspace
%     fill3([(a(1) + a(2)) * cos(theta1) 0], ...
%           [(a(1) + a(2)) * sin(theta1) 0], ...
%           zeros(1, 182), [113, 125, 140] / 255, 'FaceAlpha', 0.15);
% 
%     fill3([(a(1) + a(2)) * cos(theta1) 0], ...
%           [(a(1) + a(2)) * sin(theta1) 0], ...
%           d(1) * ones(1, 182), [113, 125, 140] / 255, 'FaceAlpha', 0.15);
%     for i = 1:181
%     plot3([(a(1)+a(2))*cos(theta1(i)) (a(1)+a(2))*cos(theta1(i))],[(a(1)+a(2))*sin(theta1(i)) (a(1)+a(2))*sin(theta1(i))],[0,d(1)],'r');
%     %theta2 = linspace(0,theta2_m,181);
%     %plot3([a(1)*cos(theta1_m)+ a(2)*cos(theta1_m+theta2(i)) robot.a(1)*cos(theta1_m)+robot.a(2)*cos(theta1_m+theta2(i))],[robot.a(1)*sin(theta1_m)+robot.a(2)*sin(theta1_m+theta2(i)) robot.a(1)*sin(theta1_m)+robot.a(2)*sin(theta1_m+theta2(i))],[robot.d(1)-d3_max robot.d(1)],'c');
%     %theta2 = linspace(0,-theta2_m,181);
%     %plot3([robot.a(1)*cos(-theta1_m)+robot.a(2)*cos(-theta1_m+theta2(i)) robot.a(1)*cos(-theta1_m)+robot.a(2)*cos(-theta1_m+theta2(i))],[robot.a(1)*sin(-theta1_m)+robot.a(2)*sin(-theta1_m+theta2(i)) robot.a(1)*sin(-theta1_m)+robot.a(2)*sin(-theta1_m+theta2(i))],[robot.d(1)-d3_max robot.d(1)],'c');
%     end

    [X, Y, Z] = sphere;  % Tạo tọa độ cho hình cầu chuẩn (bán kính 1)
    r = a2;  % Bán kính của hình cầu là chiều dài liên kết 2

    % Dịch chuyển hình cầu đến vị trí khớp 1
    X = X * r + p1(1);
    Y = Y * r + p1(2);
    Z = Z * r + p1(3);

    % Vẽ hình cầu
    surf(X, Y, Z, 'FaceColor', 'cyan', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    [A, B, C] = sphere;  % Tạo tọa độ cho hình cầu chuẩn (bán kính 1)
    f = a2+a3;  % Bán kính của hình cầu là chiều dài liên kết 2

    % Dịch chuyển hình cầu đến vị trí khớp 1
    A = A * f + p1(1);
    B = B * f + p1(2);
    C = C * f + p1(3);

    % Vẽ hình cầu
    surf(A, B, C, 'FaceColor', [128 0 128] / 255, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
end
