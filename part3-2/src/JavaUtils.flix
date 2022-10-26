namespace JavaUtils {

    pub def fromJavaIter(_: Region[r], iter: ##java.util.Iterator): Iterator[a, r] =
        import java.util.Iterator.hasNext(): Bool \ Read(r);
        import java.util.Iterator.next(): a \ {Read(r), Write(r)} as getNext;

        let done = () -> not hasNext(iter);
        let next = () -> {
            if(hasNext(iter)) {
                getNext(iter)
            } else {
                bug!("Empty iterator.")
            }
        };
        Iterator(done, next)

    pub def fromJavaList(l: ##java.util.List): List[a] = region r {
        import java.util.List.iterator(): ##java.util.Iterator \ {Read(r), Write(r)};
        iterator(l) |> fromJavaIter(r) |> Iterator.toList
    }

    pub def toJavaList(l: List[a]): ##java.util.List = region r {
        import new java.util.ArrayList(): ##java.util.List \ Write(r) as newList;
        import java.util.List.add(##java.lang.Object): Bool \ Write(r);
        let _ = r; // Defeat unused variable error
        // Would be nicer to use foreach here, but can't because foreach doesn't (yet) work
        // with immutable datastructures: https://github.com/flix/flix/issues/4485
        List.foldLeft((jl, e) -> {discard add(jl, e as ##java.lang.Object); jl}, newList(), l)
    }

    pub def fromJavaMap(m: ##java.util.Map): Map[a, b] with Order[a] = region r {
        import java.util.Map.entrySet(): ##java.util.Set \ {};
        import java.util.Set.iterator(): ##java.util.Iterator \ {Read(r), Write(r)};
        import java.util.Map$Entry.getKey(): ##java.lang.Object \ {};
        import java.util.Map$Entry.getValue(): ##java.lang.Object \ {};
        entrySet(m) |> iterator |> fromJavaIter(r) |>
            Iterator.mapL(e: ##java.util.Map$Entry -> (getKey(e) as a, getValue(e) as b)) |>
            Iterator.toMap
    }

    pub def objToString(o: a): String =
        import java.lang.Object.toString(): String \ {};
        toString(o as ##java.lang.Object)

    pub def printObject(o: a): Unit \ IO =
        println(objToString(o))

    pub def findMatches(regex: String, s: String): Option[List[String]] = region r {
        import static java.util.regex.Pattern.compile(String): ##java.util.regex.Pattern \ Write(r);
        import java.util.regex.Pattern.matcher(##java.lang.CharSequence): ##java.util.regex.Matcher \ Write(r);
        import java.util.regex.Matcher.find(): Bool \ Write(r);
        import java.util.regex.Matcher.groupCount(): Int32 \ Read(r);
        import java.util.regex.Matcher.group(Int32): String \ Read(r);

        let _ = r; // Defeat unused variable warning
        let pattern = compile(regex);
        let matches = matcher(pattern, s as ##java.lang.CharSequence);
        if (find(matches))
            Some(List.range(0, groupCount(matches)) |> List.map(i -> group(matches, i + 1)))
        else
            None
    }

}
