def main(): Unit \ IO =
    let got = #{
        ParentOf("Tywin Lannister", "Cersei Lannister").
        ParentOf("Tywin Lannister", "Jaime Lannister").
        ParentOf("Cersei Lannister", "Joffrey Baratheon").
        ParentOf("Cersei Lannister", "Myrcella Baratheon").

        SiblingOf(x, y) :- ParentOf(p, x), ParentOf(p, y), if x != y.
    };
    let siblings = query got select (x, y) from SiblingOf(x, y);
    println(siblings)