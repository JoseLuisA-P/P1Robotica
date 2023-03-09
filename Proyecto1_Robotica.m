%% Datos de los estudiantes

% Jose Alvarez      carne 19392
% Gabriel Fong      carne 19722

%% Conexion con el robotat
clear all;

robotat = robotat_connect('192.168.50.200')
ref = robotat_get_pose(robotat,1,'ZYX');
Hip = 1.65;

%% Obteniendo las medidas de X e Y del objeto 2
% Se muestran suficiente posiciones del objeto 2 para determinar la 
% totalidad de su trayectoria.

X2 = [];
Y2 = [];
Z2 = [];
THEX2 = [];
THEY2 = [];
THEZ2 =[];

for i= 1:600
    try
       temp = robotat_get_pose(robotat,2,'ZYX');
       X2(end+1) = temp(1);
       Y2(end+1) = temp(2);
       Z2(end+1) = temp(3);
       THEX2(end+1) = temp(4);
       THEY2(end+1) = temp(5);
       THEZ2(end+1) = temp(6);
    catch
        
    end
end
%% Obteniendo el centro de la trayectoria del robot 2
% Con los datos muestrados, se encuentra el punto central que describe la
% trayectoria del objeto 1
X2max = max(X2);
X2min = min(X2);
Y2max = max(Y2);
Y2min = min(Y2);
X2mid = (X2max + X2min)/2;
Y2mid = (Y2max + Y2min)/2;

%Se plotea la trayectoria para ver si es lo esperado.
hold on;
plot(X2,Y2);
axis([X2min X2max Y2min Y2max]);
plot(X2mid, Y2mid, '-o');
hold off;

%% Determinando que eje esta alineado
% Se determina que eje esta alineado del objeto en la posicion 4 y se
% coloca la posicion de este eje, la otra se determina en base al objeto 2
% y su centro de giro.

OB4 = robotat_get_pose(robotat,4,'ZYX');

X4 = OB4(1);
Y4 = OB4(2);

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

if (Xdiff > Ydiff)
    theta = asin(abs(X1-X4)/Hip);
else
    theta = asin(abs(Y4-Y1)/Hip);
end

% Comprobacion de que si sea mayor
OB3 = robotat_get_pose(robotat,3,'ZYX');

Z3 = OB3(3);

Z1 = cos(theta)*Hip;

if (Z1 < Z3)
    fprintf('El valor calculado es menor a la referencia, repetir');
else
    fprintf('Todas las medidas se ven en orden');
end

%% Comparando el error entre las mediciones

ERRX = abs((ref(1)-X1)/ref(1))*100;
ERRY = abs((ref(2)-Y1)/ref(2))*100;
ERRZ = abs((ref(3)-Z1)/ref(3))*100;

fprintf (['\nREFX ',num2str(ref(1)),'     CALCX ', num2str(X1), '  Error ',num2str(ERRX),'\n']);
fprintf (['REFY ',num2str(ref(2)),'     CALCY ', num2str(Y1),'  Error ',num2str(ERRY),'\n']);
fprintf (['REFZ ',num2str(ref(3)),'     CALCZ ', num2str(Z1),'  Error ',num2str(ERRZ),'\n']);

%% Desconexion con el robotat
robotat_disconnect(robotat);
clear robotat;

%% Graficando las posiciones en 3D

OB3MAT = transl(OB3(1),OB3(2),OB3(3))*trotx(OB3(4))*troty(OB3(5))*trotz(OB3(6));
OB4MAT = transl(OB4(1),OB4(2),OB4(3))*trotx(OB4(4))*troty(OB4(5))*trotz(OB4(6));

hold on;
trplot(OB3MAT,'frame','OB3','color','r','length',0.5);
trplot(OB4MAT,'frame','OB4','color','b','length',0.5);
hold off;