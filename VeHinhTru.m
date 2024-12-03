function VeHinhTru(handles,x0,y0,z0,r,h,colr)
% x0 y0 z0: toa do tam
% r: ban kinh day
% h: chieu cao
[X,Y,Z] = cylinder(r,100);
X = X + x0;
Y = Y + y0;
Z = Z*h + z0;
surf(X,Y,Z,'facecolor',colr,'LineStyle','none');
fill3(X(1,:),Y(1,:),Z(1,:),colr)
fill3(X(2,:),Y(2,:),Z(2,:),colr)

% function VeHinhTru(handles,u , x0, y0, z0, r, h, colr)
%     R = u(1:3, 1:3)
%     % x0, y0, z0: Tọa độ điểm gốc của hình trụ
%     % r: Bán kính đáy hình trụ
%     % h: Chiều cao của hình trụ
%     % u: Ma trận định hướng cho hình trụ (3x3)
%     % colr: Màu sắc của hình trụ
% 
%     % Tạo hình trụ chuẩn dọc theo trục Z
%     [X, Y, Z] = cylinder(r, 100);
%     Z = Z * h;  % Điều chỉnh chiều cao hình trụ
% 
%     % Xếp các tọa độ lại thành vector để dễ biến đổi
%     P = [X(:)'; Y(:)'; Z(:)'];
% 
%     % Áp dụng ma trận quay u để định hướng hình trụ
%     P_transformed = R * P;
% 
%     % Chuyển lại thành các ma trận X, Y, Z sau khi quay
%     X = reshape(P_transformed(1, :), size(X)) + x0;
%     Y = reshape(P_transformed(2, :), size(Y)) + y0;
%     Z = reshape(P_transformed(3, :), size(Z)) + z0;
% 
%     % Vẽ hình trụ bằng surf và fill3
%     surf(X, Y, Z, 'FaceColor', colr, 'LineStyle', 'none', 'FaceAlpha', 0.8);
%     fill3(X(1, :), Y(1, :), Z(1, :), colr);  % Vẽ đáy hình trụ
%     fill3(X(2, :), Y(2, :), Z(2, :), colr);  % Vẽ mặt trên hình trụ
% end
