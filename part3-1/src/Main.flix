def foo(): List[(String, Int32)] =
    let rules = #{
        Foo("x"; 1).
        Foo("x"; 2).
        Foo("x"; 5).
        Foo("y"; 2).
        Foo("y"; 3).
    };
    query rules select (x, y) from Foo(x; y)

def bar(): List[(String, Down[Int32])] =
    let rules = #{
        Bar("x"; Down(1)).
        Bar("x"; Down(2)).
        Bar("x"; Down(5)).
        Bar("y"; Down(2)).
        Bar("y"; Down(3)).
    };
    query rules select (x, y) from Bar(x; y)
