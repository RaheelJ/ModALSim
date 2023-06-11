function ialbe=DQ2Clark(theta, id, iq)

idq0=[id; iq; 0];
% This is inverse Parks Transformation 
% For inverse DQ0 transformation use sqrt(2/3) and sqrt(2)/2
K=[cos(theta)            -sin(theta)           1; 
   cos(theta-2*pi/3)     -sin(theta-2*pi/3)    1;
   cos(theta+2*pi/3)     -sin(theta+2*pi/3)    1];

iabc=K*idq0;
% Alpha-Beta Transformation
Clark=(1/3)*[2 -1 -1; 0 sqrt(3) -sqrt(3)];
ialbe=Clark*iabc;
end