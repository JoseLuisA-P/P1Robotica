%% Datos de los estudiantes


%% Conexion don el robotat
robotat = robotat_connect('192.168.50.200')
Rob1 = [0,0,0];
ref = robotat_get_pose(robotat,1,'ZYX');
%% Obteniendo las medidas de X e Y con el robot 2

X = [];
Y = [];

for i= 1:600
    try
       temp = robotat_get_pose(robotat,2,'ZYX')
       X(end+1) = temp(1);
       Y(end+1) = temp(2);
    catch
        
    end
end


%% Ploteo de datos
Xmax = max(X);
Xmin = min(X);
Ymax = max(Y);
Ymin = min(Y);
hold on;
plot(X,Y);
axis([Xmin Xmax Ymin Ymax]);
plot((Xmax+Xmin)/2,(Ymax+Ymin)/2,'-o')
hold off;

%% Obteniendo la posicion con el 3

Alin = robotat_get_pose(robotat,4,'ZYX')
Rob1(1) = (Xmax + Xmin)/2;
Rob1(2) = ((Ymax + Ymin)/2 + Alin(2))/2;

theta = rad2deg(asin(abs( Rob1(1)-Alin(1) )/ 1.67));

Rob1(3) = cos(deg2rad(theta))*1.67;

Rob2 = [ref(1:3)];

%% Desconexion con el robotat
Rob1
Rob2
robotat_disconnect(robotat);