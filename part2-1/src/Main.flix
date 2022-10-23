def main(): Unit \ IO =
    let parentList = ("Tywin Lannister", "Cersei Lannister") ::
        ("Tywin Lannister", "Jaime Lannister") ::
        ("Cersei Lannister", "Joffrey Baratheon") ::
        ("Cersei Lannister", "Myrcella Baratheon") :: Nil;

    let parents = inject parentList into ParentOf;

    let got = #{
        GrandparentOf(x, y) :- ParentOf(x, c), ParentOf(c, y).
    };
    let grandparents = query got, parents select (x, y) from GrandparentOf(x, y);
    println(grandparents)
