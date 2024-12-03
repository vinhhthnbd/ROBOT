% Tọa độ các điểm khớp
joints = [0 0 0; 1 1 1; 2 2 2]; % Ví dụ các tọa độ khớp
radius = 0.2; % Bán kính của hình trụ
height = 0.5; % Chiều dài của hình trụ (theo trục X)

% Khởi tạo đồ thị 3D
figure;
hold on;
grid on;
axis equal;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Robot Arm with Horizontal Cylindrical Joints');

% Vẽ hình trụ tại mỗi khớp
for i = 1:size(joints, 1)
    % Tạo hình trụ dọc theo trục X (vẫn dùng hàm cylinder để tạo mặt cắt tròn)
    [Y, Z, X] = cylinder(radius, 50);  % Chuyển đổi từ [X, Y, Z] sang [Y, Z, X]
    X = X * height;  % Điều chỉnh chiều dài của hình trụ theo trục X

    % Dịch chuyển hình trụ đến vị trí của khớp
    X = X + joints(i, 1);  % Dịch chuyển hình trụ theo trục X
    Y = Y + joints(i, 2);  % Dịch chuyển hình trụ theo trục Y
    Z = Z + joints(i, 3);  % Dịch chuyển hình trụ theo trục Z

    % Vẽ hình trụ
    surf(X, Y, Z, 'FaceColor', 'blue', 'EdgeColor', 'none', 'FaceAlpha', 0.7);
end

% Tùy chỉnh hiển thị
view(3);  % Hiển thị góc nhìn 3D
xlim([-1, 3]);
ylim([-1, 3]);
zlim([-1, 3]);
