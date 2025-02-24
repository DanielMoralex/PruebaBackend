
        var 0..100: x;
        var 0..100: y;
        constraint x + y == 20;
        solve maximize x;
        output [ "x = " ++ show(x) ++ ", y = " ++ show(y) ];
        