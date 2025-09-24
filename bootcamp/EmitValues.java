package bootcamp;

import com.frobozz.magic.DefaultValues;
import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;

public class EmitValues {
    public static void main(String[] args) {
        System.out.println("MAGIC_VERSION: " + DefaultValues.VERSION);
        System.out.println("GAME: " + DefaultValues.GAME);
        System.out.println(
            "SOME_FEATURE_ENABLED: " + DefaultValues.SOME_FEATURE_ENABLED);
        System.out.println("SPELLS_JSON: " + DefaultValues.SPELLS_JSON);

        Path spellsPath = Paths.get(DefaultValues.SPELLS_JSON);
        File spellsFile = spellsPath.toFile();

        if (!spellsFile.exists()) {
          System.err.println("Does not exist: " + spellsFile);
        }
    }
}
