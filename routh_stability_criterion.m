%% Determine if a system is stable or not using Routh's Stability Criterion:
% Determine number of poles (roots) in RHP (right-hand plane) and LHP 

clc; clear all; close all;

%% Initialize coefficients (of denominator):
% e.g. s^4 + 8*s^3 + 32*s^2v+ 80*s + 100 = 0  ==>> [1 8 32 80 100]
coeff = [1 8 32 80 100];

if all(coeff) == 0 % if any of the elements are 0
    disp('System is NOT STABLE')
end

%% Routh Test:
% Pre-allocate space for Routh array:
len = length(coeff);
num_cols = ceil(len/2);
if mod(length(coeff), 2) == 1 % if odd number of elements in array
    routh_array = zeros(num_cols*2 - 1, num_cols);
else
    routh_array = zeros(num_cols*2, num_cols);
end

count_top = 1;
count_bottom = 1;
% Initialize Routh array:
for i = 1:len
    if mod(i, 2) == 1  % if i is odd, add to top row 
        routh_array(1, count_top) = coeff(i);
        count_top = count_top + 1;
    else
        routh_array(2, count_bottom) = coeff(i);
        count_bottom = count_bottom + 1;
    end
end

% Calculations:
num_rows = size(routh_array, 1);
for i = 3:(num_rows - 1) % i keeps track of the current row being calculated
    for j = 1:(num_cols - 1)
        routh_array(i, j) = ((routh_array(i - 1, 1)*routh_array(i - 2, j + 1)) - (routh_array(i - 2, 1)*routh_array(i - 1, j + 1)))/routh_array(i - 1, 1);                  
    end
end
routh_array(num_rows, 1) = routh_array(num_rows - 2, 2); % drop down last element

% If 1st column contains any non-positive numbers, system is not stable:
num_poles_RHP = 0;
if any(routh_array(:, 1) <= 0)
    disp('System is NOT STABLE');
    % Count number of sign changes in 1st column:
    pos = routh_array(:, 1) > 0;
    num_changes = xor(pos(1:end - 1), pos(2:end));
    % Number of poles in RHP = number of sign changes in 1st column:
    num_poles_RHP = sum(num_changes);
else
    disp('System is STABLE');
end
% Number of poles in LHP = order - number of poles in RHP:
num_poles_LHP = (len - 1) - num_poles_RHP;

