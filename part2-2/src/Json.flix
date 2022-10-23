namespace Json {
    import com.electronwill.nightconfig.core.file.FileConfig;
    import com.electronwill.nightconfig.core.Config;
    import com.electronwill.nightconfig.core.{Config$Entry => Entry}

    import java.lang.Object
    import java.util.ArrayList

    pub def getParents(): List[(String, String)] \ IO =
        readConfigFile("../data/characters.json") |>
            getCharacters |>
            List.flatMap(getCharacterParentOf)

    def readConfigFile(filename: String): Config \ IO =
        import static com.electronwill.nightconfig.core.file.FileConfig.of(String): FileConfig \ IO as configOf;
        import com.electronwill.nightconfig.core.file.FileConfig.load(): Unit \ IO;
        let config = configOf(filename);
        load(config);
        config as Config

    def getCharacters(config: Config): List[Config] =
        import com.electronwill.nightconfig.core.Config.get(String): Object \ {};
        (get(config, "characters") as ##java.util.List) |>
            JavaUtils.fromJavaList

    def getCharacterName(config: Config): String =
        import com.electronwill.nightconfig.core.Config.get(String): Object \ {};
        get(config, "characterName") as String

    def getParentOf(config: Config): List[String] =
        import com.electronwill.nightconfig.core.Config.get(String): Object \ {};
        let parentOf = get(config, "parentOf") as ##java.util.List;
        if (Object.isNull(parentOf))
            Nil
        else
            JavaUtils.fromJavaList(parentOf)

    def getCharacterParentOf(config: Config): List[(String, String)] =
        let character = getCharacterName(config);
        getParentOf(config) |>
            List.map(offspring -> (character, offspring))
}