def main(): Unit \ IO =

    let parents = inject Json.getParents() into ParentOf;

    let got = #{
        SiblingOf(x, y) :- ParentOf(p, x), ParentOf(p, y), if x != y.
    };
    let siblings = query got, parents select (x, y) from SiblingOf(x, y);
    println(siblings)
