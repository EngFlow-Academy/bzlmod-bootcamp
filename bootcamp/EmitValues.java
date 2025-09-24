// Copyright 2025 EngFlow, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
