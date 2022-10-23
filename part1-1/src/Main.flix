def main(): Unit \ IO =
    let got = #{
        ParentOf("Tywin Lannister", "Cersei Lannister").
        ParentOf("Tywin Lannister", "Jaime Lannister").
        ParentOf("Cersei Lannister", "Joffrey Baratheon").
        ParentOf("Cersei Lannister", "Myrcella Baratheon").

        GrandparentOf(x, y) :- ParentOf(x, c), ParentOf(c, y).
    };
    let grandparents = query got select (x, y) from GrandparentOf(x, y);
    println(grandparents)