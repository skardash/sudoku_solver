function [a,err,solved] = solve_sudoku(a)
    aold = zeros(size(a));
    steps = 1;
    err = 0; solved = 0;
    while (any(aold(:) ~= a(:)) && ~err)
        aold = a;
        poss = generate_possible(a);
        noposs = cellsize(poss) == 0;
        err = any(noposs(:) & (a(:) == 0));
        if err 
            return;
        end
        [uniq_possible_sq, uniq_possible_row, uniq_possible_col] = generate_unique(poss);
        % now we can assign the open positions and apply alogorithm again and again
        a = assign_new(a, poss, uniq_possible_sq, uniq_possible_row, uniq_possible_col);
        steps = steps + 1;
        % in case there is a(i,j)=0 and poss{i,j} is empty, we have false
        % solution
    end
    if (all(a))
        solved = true;
    else 
        sz = cellsize(poss);
        sz(sz == 0) = 9;
        [C,I] = min(sz);
        [S,J] = min(C);
        ix = [I(J) J];
        cnt = 1;
        while (~solved && cnt<S+1)
            anew = a;
            anew(ix(1),ix(2)) = poss{ix(1),ix(2)}(cnt);
            [anew,err,solved] = solve_sudoku(anew);
            cnt = cnt+1;
        end
        if solved
            a = anew;
        end
        % in case sudoku is not solved yet
        % find poss
    end
end