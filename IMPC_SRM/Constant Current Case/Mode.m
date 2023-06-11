function y=Mode(x, V)

switch x
    case 1
        y=[0; 0; 0];
    case 2
        y=[2*V/3; -V/3; -V/3];
    case 3
        y=[-2*V/3; V/3; V/3];
    case 4
        y=[-V/3; 2*V/3; -V/3];
    case 5
        y=[V/3; -2*V/3; V/3];
    case 6
        y=[-V/3; -V/3; 2*V/3];
    case 7
        y=[V/3; V/3; -2*V/3];
    case 8
        y=[0; 0; 0];
    otherwise
        disp('Error! Incorrect mode inserted');        
end

end
