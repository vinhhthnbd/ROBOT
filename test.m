step = 10;
num_steps = 1000 / step;  % Số bước tính toán

% Tạo vector thời gian với num_steps phần tử
t = linspace(0, tf, num_steps);

% Khởi tạo lại các vector q, v, a với số phần tử phù hợp
q = zeros(num_steps, 1);
v = zeros(num_steps, 1);
a = zeros(num_steps, 1);

% Vòng lặp tính toán với step
for i = 1:num_steps
    % Cập nhật giá trị thời gian t
    t_current = t(i);

    % Tính toán các giá trị q, v, a tại thời gian t_current
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
disp(length(t))  % Kiểm tra độ dài của t
disp(length(q))  % Kiểm tra độ dài của q
disp(length(v))  % Kiểm tra độ dài của v
disp(length(a))  % Kiểm tra độ dài của a
%     % Tính toán tọa độ C (vị trí của điểm trên đường chuyển động)
%     lambda = q(i) / qf;  % Tỷ lệ vị trí hiện tại trên đoạn đường
%     C = A + lambda * (B - A);  % Tính tọa độ điểm C
%     x3 = C(1);
%     y3 = C(2);
%     z3 = C(3);
% 
%     % Tạo chuyển động của robot từ A đến C
%     x_a = linspace(x1, x3, 1000);
%     y_a = linspace(y1, y3, 1000);
%     z_a = linspace(z1, z3, 1000);
%     
%     % Vị trí robot
%     pWx = x_a(i*step);  % Chọn vị trí theo bước
%     pWy = y_a(i*step);
%     pWz = z_a(i*step);
% 
%     % Tính toán kinematics ngược và cập nhật vị trí
%     % (giả sử bạn có các hàm như cal_pose, DH, v.v.)
%     % (Cập nhật DH, inverse kinematics ở đây)
%     
%     % Vẽ các hình ảnh
%     % (Cập nhật phần vẽ hình ở đây)
end

% Sau vòng lặp, vẽ đồ thị
% Tạo đồ thị cho q, v, a với cùng vector thời gian t
figure;
subplot(3, 1, 1);
plot(t, q, 'LineWidth', 0.5);
xlabel('Time');
ylabel('Position (q)');

subplot(3, 1, 2);
plot(t, v, 'LineWidth', 0.5);
xlabel('Time');
ylabel('Velocity (v)');

subplot(3, 1, 3);
plot(t, a, 'LineWidth', 0.5);
xlabel('Time');
ylabel('Acceleration (a)');
