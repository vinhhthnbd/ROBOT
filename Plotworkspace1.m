function Plotworkspace1(handles)
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
% p_robot = [p1 p2 p3]';
% o_robot = [o1; o2; o3]
%     [X, Y, Z] = sphere;  % Tạo tọa độ cho hình cầu chuẩn (bán kính 1)
    %%
    r = a2+a3;
    theta_min = 0;      % Góc elevation tối thiểu (ví dụ: 30 độ)
    theta_max = 140/180*pi;      % Góc elevation tối đa (ví dụ: 90 độ)
    phi_min = 0;        % Góc azimuth tối thiểu (ví dụ: 45 độ)
    phi_max = 2*pi;      % Góc azimuth tối đa (ví dụ: 135 độ)
    [theta, phi] = meshgrid(linspace(theta_min, theta_max, 50), linspace(phi_min, phi_max, 50));
    X = r * sin(theta) .* cos(phi)+p1(1);
    Y = r * sin(theta) .* sin(phi)+p1(2);
    Z = r * cos(theta)+p1(3);
    
    % Vẽ hình cầu
    surf(X, Y, Z, 'FaceColor', 'cyan', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    %%
%     % DH Table
%     a = [0; a2];
%     alpha = [pi/2;0];
%     d = [d_val; 0];
%     theta = [0*pi/180; -50*pi/180];
%     %% HOMOGENEOUS_TRANSFORMATION_between_successive_DH_frames
%     A0_1 = DH(a(1),alpha(1),d(1),theta(1)) ;
%     A1_2 = DH(a(2),alpha(2),d(2),theta(2)) ;
%     A0_0=[1 0 0 ; 0 1 0 ; 0 0 1 ];
%     %T1 = A0_1;
%     A0_2 = A0_1 * A1_2;
%     p0 = [0;0;0];
%     [p2, o2] = cal_pose(A0_2,p0);
    f = a3;  % Bán kính của hình cầu là chiều dài liên kết 2

%     Dịch chuyển hình cầu đến vị trí khớp 1
    [A, B, C] = sphere;
    A = A * f + p2(1);
    B = B * f + p2(2);
    C = C * f + p2(3);

%     Vẽ hình cầu
    surf(A, B, C, 'FaceColor', [1, 1, 1]/255, 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    [A, B, C] = sphere;
    
end
