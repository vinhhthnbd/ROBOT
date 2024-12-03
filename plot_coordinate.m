function plot_coordinate(x,y,z,u,stt)
    
    hold on
    u=u*0.8;
    quiversensorx = quiver3(x,y,z,u(1,1),u(2,1),u(3,1));
    quiversensory = quiver3(x,y,z,u(1,2),u(2,2),u(3,2));
    quiversensorz = quiver3(x,y,z,u(1,3),u(2,3),u(3,3));
    plot3(x,y,z,'m.','MarkerSize',10);
    set(quiversensorx, 'Color', 'black');
    set(quiversensory, 'Color', [0.4940 0.1840 0.5560]);
    set(quiversensorz, 'Color', 'red');
    
    set(quiversensorx, 'LineWidth', 1.5);
    set(quiversensory, 'LineWidth', 1.5);
    set(quiversensorz, 'LineWidth', 1.5);
    textx = text(x+u(1,1),y+u(2,1),z+u(3,1),strcat('x',stt));
    set(textx,'color','black');
    texty = text(x+u(1,2),y+u(2,2),z+u(3,2),strcat('y',stt));
    set(texty,'color',[0.4940 0.1840 0.5560]);
    textz = text(x+u(1,3),y+u(2,3),z+u(3,3),strcat('z',stt));
    set(textz,'color','red');
end