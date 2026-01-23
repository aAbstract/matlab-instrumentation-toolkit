tic;

while true
    [s, l] = LT_PA105_Get_Level();
    if s == 0
        disp(l);
        break;
    end
end

dt = toc;
fprintf("%.4f seconds.\n", dt);
