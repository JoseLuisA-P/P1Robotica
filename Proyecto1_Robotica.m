%% Datos de los estudiantes

% Jose Alvarez      carne 19392
% Gabriel Fong      carne 19722

%% Conexion con el robotat
robotat = robotat_connect('192.168.50.200')
ref = robotat_get_pose(robotat,1,'ZYX');
Hip = 0;

%% Obteniendo las medidas de X e Y del objeto 2
% Se muestran suficiente posiciones del objeto 2 para determinar la 
% totalidad de su trayectoria.

X2 = [];
Y2 = [];

for i= 1:600
    try
       temp = robotat_get_pose(robotat,2,'ZYX')
       X2(end+1) = temp(1);
       Y2(end+1) = temp(2);
    catch
        
    end
end
%% Obteniendo el centro de la trayectoria del robot 2
% Con los datos muestrados, se encuentra el punto central que describe la
% trayectoria del objeto 1
X2max = max(X2);
X2min = min(X2);
Y2max = max(Y2);
Ymin = min(Y2);
X2mid = (X2max + X2min)/2;
Y2mid = (Y2max + Y2min)/2;

%Se plotea la trayectoria para ver si es lo esperado.
hold on;
plot(X,Y);
axis([X2min X2max Y2min Y2max]);
plot(X2mid, Y2mid, '-o');
hold off;

%% Determinando que eje esta alineado
% Se determina que eje esta alineado del objeto en la posicion 4 y se
% coloca la posicion de este eje, la otra se determina en base al objeto 2
% y su centro de giro.

[X4,Y4,~,~,~,~,~] = robotat_get_pose(robotat,4,'ZYX');

Xdiff = abs(X2mid - X4);
Ydiff = abs(Y2mid - Y4);

if (Xdiff < Ydiff)
    Xreal = (X4 + X2mid)/2;
    X1 = Xreal;
    Y1 = Y2mid;
else
    Yreal = (Y4 + Y2mid)/2;
    X1 = X2mid;
    Y1 = Yreal;
end


%% Determinando la altura en Z con la medida de la hipotenusa

if (Xdiff < Ydiff)
    theta = acos( abs(X1-X4)/Hip );
else
    theta = acos( abs(Y1-Y4)/Hip );
end

% Comprobacion de que si sea mayor
[~,~,Z3,~,~,~,~] = robotat_get_pose(robotat,3,'ZYX');

Z1 = sin(theta)*Hip;

if (Z1 < Z3)
    fprintf('El valor calculado es menor a la referencia, repetir');
else
    fprintf('Todas las medidas se ven en orden');
end

%% Comparando el error entre las mediciones

[X1T,Y1T,Z1T,~,~,~,~] = robotat_get_pose(robotat,1,'ZYX');


%% Desconexion con el robotat
robotat_disconnect(robotat);