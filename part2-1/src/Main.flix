def main(): Unit \ IO =
    let parentList = ("Tywin Lannister", "Cersei Lannister") ::
        ("Tywin Lannister", "Jaime Lannister") ::
        ("Cersei Lannister", "Joffrey Baratheon") ::
        ("Cersei Lannister", "Myrcella Baratheon") :: Nil;

    let parents = inject parentList into ParentOf;

    let got = #{
        SiblingOf(x, y) :- ParentOf(p, x), ParentOf(p, y), if x != y.
    };

    let siblings = query got, parents select (x, y) from SiblingOf(x, y);

    println(siblings)
