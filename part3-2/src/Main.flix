def main(): Unit \ IO =

    let relationshipTypes = "parents" :: "parentOf" :: "killed" :: "killedBy" ::
        "serves" :: "servedBy" :: "guardianOf" :: "guardedBy" :: "siblings" ::
        "marriedEngaged" :: "allies" :: Nil;
    let relationships = Json.getRelationships(relationshipTypes);

    let related = inject relationships into Related;

    let rules = #{
        Degree(x; Down(0)) :- Root(x).
        Degree(x; n + Down(1)) :- Degree(y; n), Related(y, x).
    };

    let root = inject "Tyrion Lannister" :: Nil into Root;

    println(query rules, related, root select (x, d) from Degree(x; d))
