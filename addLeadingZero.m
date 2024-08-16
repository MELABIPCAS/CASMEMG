function output = addLeadingZero(input)
    % Check if the input is an integer and less than 10
    if isnumeric(input) && input < 10 && input >= 0 && floor(input) == input
        % Add a leading zero
        output = ['0' num2str(input)];
    else
        % Convert the input to a string without modification
        output = num2str(input);
    end
end