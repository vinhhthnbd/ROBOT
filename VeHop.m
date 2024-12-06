% Định nghĩa tham số
radius = 5;            % Bán kính của phần hình cầu
theta_min = 0;      % Góc elevation tối thiểu (ví dụ: 30 độ)
theta_max = 140/180*pi;      % Góc elevation tối đa (ví dụ: 90 độ)
phi_min = 0;        % Góc azimuth tối thiểu (ví dụ: 45 độ)
phi_max = 2*pi;      % Góc azimuth tối đa (ví dụ: 135 độ)

% Tạo lưới các góc theta và phi
% [theta, phi] = meshgrid(linspace(theta_min, theta_max, 50), linspace(phi_min, phi_max, 50));

% Chuyển từ tọa độ cầu sang tọa độ Descartes
x = radius * sin(theta) .* cos(phi);
y = radius * sin(theta) .* sin(phi);
z = radius * cos(theta);

% Vẽ Spherical Sector
figure;
surf(x, y, z, 'FaceColor', 'b', 'FaceAlpha', 0.7, 'EdgeColor', 'none');
axis equal;

% Thêm tiêu đề và nhãn trục
title('Spherical Sector');
xlabel('X');
ylabel('Y');
zlabel('Z');
grid on;
