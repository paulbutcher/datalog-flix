def main(): Unit \ IO =

    let relationshipTypes = "parents" :: "parentOf" :: "killed" :: "killedBy" ::
        "serves" :: "servedBy" :: "guardianOf" :: "guardedBy" :: "siblings" ::
        "marriedEngaged" :: "allies" :: Nil;
    let relationships = Json.getRelationships(relationshipTypes);

    let related = inject relationships into Related;

    let rules = #{
        Degree(x; Down(0)) :- Root(x).
        Degree(x; n + Down(1)) :- Degree(y; n), Related(y, x).
        AggregatedDegree(n; Set#{x}) :- fix Degree(x; n).
        DegreeCount(n, Set.size(s)) :- fix AggregatedDegree(n; s).
    };

    let root = inject "Tyrion Lannister" :: Nil into Root;

    query rules, related, root select (d, c) from DegreeCount(d, c) |>
        List.foreach(match (d, c) -> println("Separated by degree ${d}: ${c}"))
