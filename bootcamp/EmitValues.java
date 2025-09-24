package bootcamp;

import com.frobozz.magic.DefaultValues;
import java.io.File;

public class EmitValues {
    public static void main(String[] args) {
        System.out.println("MAGIC_VERSION: " + DefaultValues.VERSION);
        System.out.println("GAME: " + DefaultValues.GAME);
        System.out.println(
          "SOME_FEATURE_ENABLED: " + DefaultValues.SOME_FEATURE_ENABLED);
        System.out.println("PWD: " + System.getenv("PWD"));
        System.out.println("SPELLS_JSON: " + DefaultValues.SPELLS_JSON);

        File spellsFile = new File(DefaultValues.SPELLS_JSON);

        if (!spellsFile.exists()) {
          System.err.println("Does not exist: " + spellsFile);
        }
    }
}
