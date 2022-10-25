namespace Json {
    import com.electronwill.nightconfig.core.file.FileConfig;
    import com.electronwill.nightconfig.core.Config;
    import com.electronwill.nightconfig.core.{Config$Entry => Entry}

    import java.lang.Object
    import java.util.ArrayList

    pub def getRelationships(relationshipTypes: List[String]): List[(String, String)] \ IO =
        let characters = getCharacters();
        relationshipTypes |>
            List.flatMap(rt ->
                characters |> List.flatMap(getCharacterRelationship(rt)))

    def getCharacters(): List[Config] \ IO =
        import com.electronwill.nightconfig.core.Config.get(String): Object \ {};
        let config = readConfigFile("../data/characters.json");
        (get(config, "characters") as ##java.util.List) |>
            JavaUtils.fromJavaList

    def readConfigFile(filename: String): Config \ IO =
        import static com.electronwill.nightconfig.core.file.FileConfig.of(String): FileConfig \ IO as configOf;
        import com.electronwill.nightconfig.core.file.FileConfig.load(): Unit \ IO;
        let config = configOf(filename);
        load(config);
        config as Config

    def getCharacterName(config: Config): String =
        import com.electronwill.nightconfig.core.Config.get(String): Object \ {};
        get(config, "characterName") as String

    def getRelationship(relationship: String, config: Config): List[String] =
        import com.electronwill.nightconfig.core.Config.get(String): Object \ {};
        let parentOf = get(config, relationship) as ##java.util.List;
        if (Object.isNull(parentOf))
            Nil
        else
            JavaUtils.fromJavaList(parentOf)

    def getCharacterRelationship(relationship: String, config: Config): List[(String, String)] =
        let character = getCharacterName(config);
        getRelationship(relationship, config) |>
            List.map(offspring -> (character, offspring))
}