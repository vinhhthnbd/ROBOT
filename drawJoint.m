function drawJoint(handles,theta1, x, y, z, radius, height, colr)

% Đầu tiên, tạo hình cylinder
[X, Y, Z] = cylinder(radius, 100); 
Z = Z * height - height / 2; 

% Xoay quanh trục X
theta = (90)/180*pi;  
R_x = [1 0 0; 0 cos(theta) -sin(theta); 0 sin(theta) cos(theta)];
coords = R_x * [X(:)'; Y(:)'; Z(:)'];  

% Quay quanh trục Z
theta_z = theta1;  
R_z = [cos(theta_z) -sin(theta_z) 0; sin(theta_z) cos(theta_z) 0; 0 0 1];  % Ma trận quay quanh trục Z
coords_z = R_z * coords;  % Áp dụng phép quay quanh trục Z

X_rot = reshape(coords_z(1, :), size(X));
Y_rot = reshape(coords_z(2, :), size(Y));
Z_rot = reshape(coords_z(3, :), size(Z));

X_rot = X_rot + x;
Y_rot = Y_rot + y;
Z_rot = Z_rot + z;

surf(handles, X_rot, Y_rot, Z_rot, 'FaceColor', colr(1:3), 'EdgeColor', 'none');

fill3(handles, X_rot(1,:), Y_rot(1,:), Z_rot(1,:), colr(1:3), 'EdgeColor', '#000000');
fill3(handles, X_rot(2,:), Y_rot(2,:), Z_rot(2,:), colr(1:3), 'EdgeColor', '#000000');
