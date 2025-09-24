package bootcamp;

import com.frobozz.magic.DefaultValues;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

public class EmitValues {
    public static void main(String[] args) {
        System.out.println("MAGIC_VERSION: " + DefaultValues.VERSION);
        System.out.println("GAME: " + DefaultValues.GAME);
        System.out.println( "SOME_FEATURE_ENABLED: " +
            DefaultValues.SOME_FEATURE_ENABLED);
        System.out.println("SPELLS_JSON: " + DefaultValues.SPELLS_JSON);

        try (BufferedReader in = new BufferedReader(
            new FileReader(DefaultValues.SPELLS_JSON))) {

            String line;
            while ((line = in.readLine()) != null) {
                System.out.println(line);
            }
        } catch (Throwable t) {
            System.err.println(t.getMessage());
            System.exit(1);
        }
    }
}
