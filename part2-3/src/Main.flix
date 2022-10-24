def main(): Unit \ IO =

    let characters = Json.getCharacters();
    let relationshipTypes = "parents" :: "parentOf" :: "killed" :: "killedBy" ::
        "serves" :: "servedBy" :: "guardianOf" :: "guardedBy" :: "siblings" ::
        "marriedEngaged" :: "allies" :: Nil;
    let relationships = List.flatMap(Json.getRelationships(characters), relationshipTypes);

    let related = inject relationships into Related;
    let rules = #{
        DirectlyRelated(x) :- Root(y), Related(y, x), not Root(x).
    };

    def degreesOfSeparation(deg: Int32, cs: List[String]): Unit \ IO = {
        let root = inject cs into Root;
        let directlyRelated = query rules, root, related select (x) from DirectlyRelated(x);
        match List.length(directlyRelated) {
            case count if count > 0 =>
                println("Separated by degree ${deg}: ${count}");
                degreesOfSeparation(deg + 1, cs ::: directlyRelated)
            case _ =>
                println("Nobody separated by degree ${deg}")
        }
    };

    degreesOfSeparation(1, "Tyrion Lannister" :: Nil)
