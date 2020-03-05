function result = diff_steps(origin, steps)

len = length(origin);
result = zeros(len, 1);

for i = 1 : len
    if(i <= steps)
        result(i) = origin(i);
    else
        result(i) = origin(i) - origin(i - steps);
    end
end

end